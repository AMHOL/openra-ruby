require 'json'

module Openra
  class CLI
    module Commands
      class ReplayData < Hanami::CLI::Command
        desc 'Output replay data to stdout'

        argument :replay, required: true, desc: 'Path of the replay file to read data from'
        option :format, default: 'json', values: %w(json pretty-json), desc: 'Output format'

        def call(replay:, **options)
          replay = OpenRA::Replays::Replay.new(replay)

          client_index_mapping = {}
          players = replay.metadata.each_with_object([]) do |(key, value), arr|
            next unless key.start_with?('Player')
            arr << value['Name']
          end

          replay_data = {
            mod: replay.mod,
            version: replay.version,
            map: {
              name: replay.map_title,
              hash: replay.map_id
            },
            game: {
              start_time: replay.start_time,
              end_time: replay.end_time,
              duration: replay.duration
            },
            clients: [],
            chat: []
          }

          replay.orders.each do |order|
            case order.command
            when 'SyncLobbyClients'
              clients = Openra::YAML.load(order.target)
              clients.each_pair do |_, client|
                next if client_index_mapping.include?(client['Index'])

                replay_data[:clients] << {
                  index: client['Index'],
                  name: client['Name'],
                  preferred_color: client['PreferredColor'],
                  color: client['Color'],
                  faction: client['Faction'],
                  ip: client['IpAddress'],
                  team: client['Team'] == 0 ? nil : client['Team'],
                  is_bot: client['Bot'].nil? ? false : true,
                  is_admin: client['IsAdmin'] == 'True',
                  is_player: players.include?(client['Name']),
                  build: []
                }

                client_index_mapping[client['Index']] = client
              end
            when 'PlaceBuilding'
              client = replay_data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              client[:build] << {
                structure: order.target_string,
                placement: {
                  x: order.target_x,
                  y: order.target_y
                }
              }
            when 'Chat'
              client = replay_data[:clients].find do |candidate|
                candidate[:index] == order.client_index.to_s
              end

              replay_data[:chat] << {
                name: client[:name],
                message: order.target
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
      end
    end
  end
end
