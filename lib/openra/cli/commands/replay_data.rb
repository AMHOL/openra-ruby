# frozen_string_literal: true

module Openra
  class CLI
    module Commands
      class ReplayData < Dry::CLI::Command
        desc 'Output replay data to stdout'

        argument :replay, required: true, desc: 'Path of the replay file to read data from'
        option :format, default: 'json', values: %w(json pretty-json yaml), desc: 'Output format'

        def call(replay:, **options)
          replay = Openra::Replays::Replay.new(replay)
          support_powers = SUPPORT_POWERS.fetch(replay.metadata.mod, {})

          data = {
            mod: replay.metadata.mod,
            version: replay.metadata.version,
            server_name: nil,
            map: {
              name: replay.metadata.map_name,
              hash: replay.metadata.map_hash
            },
            game: {
              type: replay.players.each_with_object(Hash.new(0)) { |player, hash|
                if player.team.nil?
                  hash[SecureRandom.uuid] += 1
                else
                  hash[player.team] += 1
                end
              }.values.join('v'),
              start_time: replay.metadata.start_time.iso8601,
              end_time: replay.metadata.end_time.iso8601,
              duration: time((replay.metadata.end_time - replay.metadata.start_time) * 1000),
              options: nil
            },
            clients: [],
            chat: []
          }

          game_started = false
          current_sync_clients = []
          sync_info = nil

          replay.each_order do |order|
            client = current_sync_clients.find do |candidate|
              candidate.index == order.client_index.to_s
            end

            case order.command
            when 'StartGame'
              game_started = true

              data[:clients] = sync_info.clients.map do |client|
                player = replay.player(client.index)

                {
                  index: client.index,
                  name: client.name,
                  preferred_color: client.preferred_color,
                  color: client.color,
                  spawn: {
                    random: player&.is_random_spawn,
                    point: client.spawn_point
                  },
                  faction: {
                    chosen: client.faction_name.downcase,
                    actual: player&.faction_id
                  },
                  ip: client.ip,
                  team: player&.team,
                  is_bot: player&.is_bot || false,
                  is_admin: client.is_admin,
                  is_player: !player.nil?,
                  is_winner: player&.outcome == 'Won',
                  build: [],
                  support_powers: support_powers.values.product([0]).to_h
                }
              end

              data[:game][:options] = {
                explored_map: sync_info.global_settings.game_options.explored_map_enabled.value,
                speed: sync_info.global_settings.game_options.game_speed.value,
                starting_cash: sync_info.global_settings.game_options.starting_cash.value,
                starting_units: sync_info.global_settings.game_options.starting_units.value,
                fog_enabled: sync_info.global_settings.game_options.fog_enabled.value,
                cheats_enabled: sync_info.global_settings.game_options.cheats_enabled.value,
                kill_bounty_enabled: sync_info.global_settings.game_options.bounties_enabled.value,
                allow_undeploy: sync_info.global_settings.game_options.conyard_undeploy_enabled.value,
                crates_enabled: sync_info.global_settings.game_options.crates_enabled.value,
                build_off_allies: sync_info.global_settings.game_options.build_off_allies_enabled.value,
                restrict_build_radius: sync_info.global_settings.game_options.restricted_build_radius_enabled.value,
                short_game: sync_info.global_settings.game_options.short_game_enabled.value,
                techlevel: sync_info.global_settings.game_options.tech_level.value
              }
            when 'SyncInfo'
              sync_info = Openra::Struct::SyncInfo.new(
                Openra::YAML.load(order.target)
              ) unless game_started
            when 'SyncLobbyClients'
              current_sync_clients = Openra::Struct::SyncLobbyClients.new(
                Openra::YAML.load(order.target)
              ).clients
            when *support_powers.keys
              key = support_powers.fetch(order.command.force_encoding('UTF-8'))
              client_hash = data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              client_hash[:support_powers][key] += 1
            when 'PlaceBuilding'
              client_hash = data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              client_hash[:build] << {
                structure: order.target,
                game_time: time(order.frame * sync_info.global_settings.frametime_multiplier),
                placement: order.target_pos.to_i
              }
            when 'Message'
              data[:chat] << {
                channel: 'server',
                name: nil,
                message: order.target
              }
            when 'Chat'
              data[:chat] << {
                channel: 'global',
                name: client.name,
                message: order.target
              }
            when 'TeamChat'
              data[:chat] << {
                channel: client.team,
                name: client.name,
                message: order.target
              }
            end
          end

          data[:server_name] = sync_info.global_settings.server_name

          puts FORMATTERS.fetch(options[:format]).call(data)
        end

        private

        def time(msec)
          sec = msec / 1000
          mm, ss = sec.divmod(60)
          hh, mm = mm.divmod(60)

          {
            formatted: '%02d:%02d:%02d' % [hh, mm, ss],
            msec: msec.to_i
          }
        end
      end
    end
  end
end
