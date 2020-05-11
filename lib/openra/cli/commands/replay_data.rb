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

          current_sync_clients = []
          current_sync_info = nil

          replay.each_order do |order|
            client = current_sync_clients.find do |candidate|
              candidate.index == order.client_index.to_s
            end

            case order.command
            when 'StartGame'
              data[:clients] = current_sync_info.clients.map do |client|
                player = replay.player(client.index)
                player_index = replay.players.index(player) + FIRST_PLAYER_INDEX if player

                {
                  index: client.index,
                  player_index: player_index,
                  name: utf8(client.name),
                  fingerprint: client.fingerprint,
                  preferred_color: client.preferred_color,
                  color: client.color,
                  spawn: {
                    random: player&.is_random_spawn,
                    point: client.spawn_point
                  },
                  faction: {
                    random: player&.is_random_faction,
                    chosen: client.faction_name.downcase,
                    actual: player&.faction_id
                  },
                  ip: client.ip,
                  team: player&.team,
                  is_bot: player&.is_bot || false,
                  is_admin: client.is_admin,
                  is_player: !player.nil?,
                  is_winner: player&.outcome == 'Won',
                  outcome_time: player&.outcome_time&.iso8601,
                  build: [],
                  support_powers: []
                }
              end

              data[:game][:options] = {
                explored_map: current_sync_info.global_settings.game_options.explored_map_enabled.value,
                speed: current_sync_info.global_settings.game_options.game_speed.value,
                starting_cash: current_sync_info.global_settings.game_options.starting_cash.value,
                starting_units: current_sync_info.global_settings.game_options.starting_units.value,
                fog_enabled: current_sync_info.global_settings.game_options.fog_enabled.value,
                cheats_enabled: current_sync_info.global_settings.game_options.cheats_enabled.value,
                kill_bounty_enabled: current_sync_info.global_settings.game_options.bounties_enabled.value,
                allow_undeploy: current_sync_info.global_settings.game_options.conyard_undeploy_enabled.value,
                crates_enabled: current_sync_info.global_settings.game_options.crates_enabled.value,
                build_off_allies: current_sync_info.global_settings.game_options.build_off_allies_enabled.value,
                restrict_build_radius: current_sync_info.global_settings.game_options.restricted_build_radius_enabled.value,
                short_game: current_sync_info.global_settings.game_options.short_game_enabled.value,
                techlevel: current_sync_info.global_settings.game_options.tech_level.value
              }
            when 'SyncInfo'
              current_sync_info = Openra::Struct::SyncInfo.new(
                Openra::MiniYAML.load(order.target)
              )
              current_sync_clients = current_sync_info.clients
            when 'SyncLobbyClients'
              current_sync_clients = Openra::Struct::SyncLobbyClients.new(
                Openra::MiniYAML.load(order.target)
              ).clients
            when *support_powers.keys
              key = support_powers.fetch(utf8(order.command))
              client_hash = data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              client_hash[:support_powers] << {
                type: key,
                game_time: time(order.frame.pred * current_sync_info.global_settings.frametime_multiplier),
                placement: cell(order.target_cell.to_i),
                extra_placement: cell(order.extra_cell.to_i),
              }
            when 'PlaceBuilding'
              # subject_id stores the player index here
              # as bot commands are issued by the host client
              client_hash = data[:clients].find do |candidate|
                candidate[:player_index] == order.subject_id
              end

              client_hash[:build] << {
                structure: utf8(order.target),
                game_time: time(order.frame.pred * current_sync_info.global_settings.frametime_multiplier),
                placement: cell(order.target_cell.to_i)
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

          data[:server_name] = utf8(current_sync_info.global_settings.server_name)

          puts FORMATTERS.fetch(options[:format]).call(data)
        end
      end
    end
  end
end
