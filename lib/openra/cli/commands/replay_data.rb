# frozen_string_literal: true

module Openra
  class CLI
    module Commands
      class ReplayData < Dry::CLI::Command
        include CLI::Utils

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
              name: utf8(replay.metadata.map_name),
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
                player_index = replay.players.index(player) + FIRST_PLAYER_INDEX if player

                {
                  index: client.index,
                  player_index: player_index,
                  name: utf8(client.name),
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
                  support_powers: []
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
              key = support_powers.fetch(utf8(order.command))
              client_hash = data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              client_hash[:support_powers] << {
                type: key,
                game_time: time(order.frame * sync_info.global_settings.frametime_multiplier),
                placement: order.target_pos.to_i,
                extra_placement: order.extra_pos.to_i
              }
            when 'PlaceBuilding'
              # subject_id stores the player index here
              # as bot commands are issued by the host client
              client_hash = data[:clients].find do |candidate|
                candidate[:player_index] == order.subject_id
              end

              client_hash[:build] << {
                structure: utf8(order.target),
                game_time: time(order.frame * sync_info.global_settings.frametime_multiplier),
                placement: order.target_pos.to_i
              }
            when 'Message'
              data[:chat] << {
                channel: 'server',
                name: nil,
                message: utf8(order.target)
              }
            when 'Chat'
              data[:chat] << {
                channel: 'global',
                name: utf8(client.name),
                message: utf8(order.target)
              }
            when 'TeamChat'
              data[:chat] << {
                channel: client.team,
                name: utf8(client.name),
                message: utf8(order.target)
              }
            end
          end

          data[:server_name] = utf8(sync_info.global_settings.server_name)

          puts FORMATTERS.fetch(options[:format]).call(data)
        end
      end
    end
  end
end
