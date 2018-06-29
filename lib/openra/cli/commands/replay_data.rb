require 'json'

module Openra
  class CLI
    module Commands
      class ReplayData < Hanami::CLI::Command
        ORDER_LATENCY_MAPPING = {
          'slowest' => 2,
          'slower' => 3,
          'default' => 3,
          'fast' => 4,
          'faster' => 4,
          'fastest' => 6
        }.freeze

        desc 'Output replay data to stdout'

        argument :replay, required: true, desc: 'Path of the replay file to read data from'
        option :format, default: 'json', values: %w(json pretty-json), desc: 'Output format'

        def call(replay:, **options)
          replay = Openra::Replays::Replay.new(replay)

          players = replay.metadata.each_with_object([]) do |(key, value), arr|
            next unless key.start_with?('Player')
            arr << value
          end
          player_mapping = players.each_with_object({}) do |player, mapping|
            mapping[player['ClientIndex']] = player
          end
          player_teams = players.map { |player| player['Team'] }
          team_alignment = player_teams.each_with_object({}) do |team, hash|
            if team == 0
              hash[SecureRandom.uuid] = 1
            else
              hash[team] ||= 0
              hash[team] += 1
            end
          end

          replay_data = {
            mod: replay.mod,
            version: replay.version,
            server_name: nil,
            map: {
              name: utf8(replay.map_title),
              hash: replay.map_id
            },
            game: {
              type: team_alignment.values.join('v'),
              start_time: replay.start_time,
              end_time: replay.end_time,
              duration: replay.duration,
              options: {}
            },
            clients: [],
            chat: []
          }

          timestep = nil
          sync_info_orders = replay.orders.select do |order|
            order.command == 'SyncInfo'
          end

          sync_info_orders.reverse.each.with_index do |sync_info_order, index|
            sync_info = Openra::YAML.load(sync_info_order.target)

            # Get all clients
            sync_info.each_pair do |key, data|
              case key
              when /^Client@/
                replay_data[:clients] << {
                  index: data['Index'],
                  name: utf8(data['Name']),
                  preferred_color: data['PreferredColor'],
                  color: data['Color'],
                  faction: data['Faction'],
                  ip: data['IpAddress'],
                  team: data['Team'].to_s == '0' ? nil : data['Team'],
                  is_bot: data['Bot'].nil? ? false : true,
                  is_admin: data['IsAdmin'] == 'True',
                  is_player: player_mapping.fetch(data['Index'], false) != false,
                  is_winner: player_mapping.fetch(data['Index'], {}).fetch('Outcome', nil) == 'Won',
                  build: []
                } unless replay_data[:clients].any? { |client| client[:index] == data['Index'] }
              when 'GlobalSettings'
                next unless index.zero?

                timestep = Integer(data['Timestep']) * ORDER_LATENCY_MAPPING.fetch(
                  data['Options']['gamespeed']['Value'],
                  ORDER_LATENCY_MAPPING['default']
                )

                replay_data[:server_name] = data['ServerName']
                replay_data[:game][:options] = {
                  explored_map: data['Options']['explored']['Value'] == 'True',
                  speed: data['Options']['gamespeed']['Value'],
                  starting_cash: data['Options']['startingcash']['Value'],
                  starting_units: data['Options']['startingunits']['Value'],
                  fog_enabled: data['Options']['fog']['Value'] == 'True',
                  cheats_enabled: data['Options']['cheats']['Value'] == 'True',
                  kill_bounty_enabled: data['Options']['bounty']['Value'] == 'True',
                  allow_undeploy: data['Options']['factundeploy']['Value'] == 'True',
                  crates_enabled: data['Options']['crates']['Value'] == 'True',
                  build_off_allies: data['Options']['allybuild']['Value'] == 'True',
                  restrict_build_radius: data['Options']['buildradius']['Value'] == 'True',
                  short_game: data['Options']['shortgame']['Value'] == 'True',
                  techlevel: data['Options']['techlevel']['Value']
                }
              end
            end
          end

          replay.orders.each do |order|
            case order.command
            when 'PlaceBuilding'
              client = replay_data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              current_time = order.frame * timestep
              current_time_seconds = current_time / 1000
              mm, ss = current_time_seconds.divmod(60)
              hh, mm = mm.divmod(60)

              client[:build] << {
                structure: order.target_string,
                game_time: {
                  formatted: '%02d:%02d:%02d' % [hh, mm, ss],
                  msec: current_time
                },
                placement: {
                  x: order.target_x,
                  y: order.target_y
                }
              }
            when 'Message'
              replay_data[:chat] << {
                channel: :server,
                name: nil,
                message: utf8(order.target)
              }
            when 'Chat'
              client = replay_data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              replay_data[:chat] << {
                channel: :global,
                name: client[:name],
                message: utf8(order.target)
              }
            when 'TeamChat'
              client = replay_data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              replay_data[:chat] << {
                channel: client[:team],
                name: client[:name],
                message: utf8(order.target)
              }
            end
          end

          case options[:format]
          when 'json'
            puts JSON.dump(replay_data)
          when 'pretty-json'
            puts JSON.pretty_generate(replay_data)
          end
        end

        private

        def utf8(string)
          string.force_encoding('UTF-8')
        end
      end
    end
  end
end
