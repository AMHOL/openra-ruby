# frozen_string_literal: true

module Openra
  class CLI
    module Commands
      class ReplayData < Dry::CLI::Command
        desc 'Output replay data to stdout'

        argument :replay, required: true, desc: 'Path of the replay file to read data from'
        option :format, default: 'json', values: %w(json pretty-json yaml), desc: 'Output format'

        def call(replay:, **options)
          data = Openra::Commands::Replays::ExtractData.new.call(replay)
          puts FORMATTERS.fetch(options[:format]).call(data)
        end
      end
    end
  end
end
