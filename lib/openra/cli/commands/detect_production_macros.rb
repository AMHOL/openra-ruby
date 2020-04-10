module Openra
  class CLI
    module Commands
      class DetectProductionMacros < Hanami::CLI::Command
        ARRAY_HASH = ->(hash, key) { hash[key] = [] }

        desc 'Detect whether players are using production macros'

        argument :replay, required: true, desc: 'Path of the replay file to read data from'
        option :format, default: 'json', values: %w(json pretty-json yaml), desc: 'Output format'

        def call(replay:, **options)
          replay = Openra::Replays::Replay.new(replay)
          commands = Hash.new(&ARRAY_HASH)

          replay.orders.each do |order|
            case order.command
            when 'StartProduction'
              commands[order.client_index.to_s] << {
                target: order.target.to_s,
                msec: order.frame * replay.frametime_multiplier
              }
            end
          end

          data = {
            players: replay.players.select(&:is_human).map { |player|
              player_commands = commands_with_delay(commands[player.index])
              production_stats = production_stats(player_commands)
              sequences = detect_sequences(player_commands)

              {
                index: player.index,
                name: player.name,
                team: player.team,
                outcome: player.outcome,
                production_stats: production_stats,
                sequences: sequences,
                suspected_macros: suspected_macros(production_stats, sequences)
              }
            }
          }

          puts FORMATTERS.fetch(options[:format]).call(data)
        end

        private

        def commands_with_delay(commands)
          commands.inject do |last_command, command|
            command[:delay] = command[:msec] - last_command[:msec]
            command
          end

          # Drop the first command, as we don't have a delay for that
          commands.drop(1)
        end

        def detect_sequences(player_commands)
          sequences = []
          groups = player_commands.each_with_object(Hash.new(&ARRAY_HASH)).with_index do |(command, hash), index|
            hash[command[:delay]] << command.merge(index: index)
          end

          groups.each_pair do |delay, commands|
            sequence = []

            commands.inject do |last_command, command|
              if last_command[:index].next == command[:index]
                sequence << command
              elsif sequence.length > 1
                sequences << {
                  delay: delay,
                  sequence: sequence.map { |c| c[:target] }
                }
                sequence = []
              end

              command
            end
          end

          sequences = sequences.uniq.map do |sequence|
            sequence.merge(
              occurences: sequences.count { |current| current == sequence }
            )
          end

          sequences.select { |sequence| sequence[:occurences] > 1 }.sort do |a, b|
            b[:occurences] <=> a[:occurences]
          end
        end

        def production_stats(player_commands)
          order_delays = player_commands.map { |command| command[:delay] }

          {
            order_delay: {
              min: order_delays.min,
              max: order_delays.max,
              mean: mean(order_delays),
              median: median(order_delays)
            }
          }
        end

        def suspected_macros(production_stats, sequences)
          suspicious_sequences = sequences.count do |sequence|
            sequence[:delay] < 100 &&
              sequence[:sequence].length > 3 &&
              sequence[:sequence].uniq.length > 2
          end

          production_stats[:order_delay][:min] < 50 || suspicious_sequences > 0
        end

        def mean(ints)
          ints.sum / ints.length
        end

        def median(ints)
          ints = ints.sort
          middle_index = (ints.length - 1) / 2.0

          (ints[middle_index.floor] + ints[middle_index.ceil]) / 2
        end
      end
    end
  end
end
