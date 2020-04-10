module Openra
  class CLI
    module Commands
      class ReplayData < Dry::CLI::Command
        desc 'Output replay data to stdout'

        argument :replay, required: true, desc: 'Path of the replay file to read data from'
        option :format, default: 'json', values: %w(json pretty-json yaml), desc: 'Output format'

        def call(replay:, **options)
          replay = Openra::Replays::Replay.new(replay)

          data = {
            mod: replay.metadata.mod,
            version: replay.metadata.version,
            server_name: replay.global_settings.server_name,
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
              options: {
                explored_map: replay.game_options.explored_map_enabled.value,
                speed: replay.game_options.game_speed.value,
                starting_cash: replay.game_options.starting_cash.value,
                starting_units: replay.game_options.starting_units.value,
                fog_enabled: replay.game_options.fog_enabled.value,
                cheats_enabled: replay.game_options.cheats_enabled.value,
                kill_bounty_enabled: replay.game_options.bounties_enabled.value,
                allow_undeploy: replay.game_options.conyard_undeploy_enabled.value,
                crates_enabled: replay.game_options.crates_enabled.value,
                build_off_allies: replay.game_options.build_off_allies_enabled.value,
                restrict_build_radius: replay.game_options.restricted_build_radius_enabled.value,
                short_game: replay.game_options.short_game_enabled.value,
                techlevel: replay.game_options.tech_level.value
              }
            },
            clients: replay.clients.map { |client|
              player = replay.player(client.index)

              {
                index: client.index,
                name: client.name,
                preferred_color: client.preferred_color,
                color: client.preferred_color,
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
                build: []
              }
            },
            chat: []
          }

          current_sync_clients = []

          replay.orders.each do |order|
            client = current_sync_clients.find do |candidate|
              candidate.index == order.client_index.to_s
            end

            case order.command
            when 'SyncLobbyClients'
              current_sync_clients = Openra::Struct::SyncLobbyClients.new(
                Openra::YAML.load(order.target)
              ).clients
            when 'PlaceBuilding'
              client_hash = data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              client_hash[:build] << {
                structure: utf8(order.target),
                game_time: time(order.frame * replay.frametime_multiplier),
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
                name: client.name,
                message: utf8(order.target)
              }
            when 'TeamChat'
              data[:chat] << {
                channel: client.team,
                name: client.name,
                message: utf8(order.target)
              }
            end
          end

          puts FORMATTERS.fetch(options[:format]).call(data)
        end

        private

        def utf8(string)
          string.force_encoding('UTF-8').to_s
        end

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
