module OpenRA
  module Replays
    class Replay
      attr_reader :file

      def initialize(filename)
        @file = OpenRA::Replays::File.new(filename)
      end

      def metadata
        @metadata ||= YAML.load(file.metadata.data.gsub(/\t/, '  '))
      end

      def orders
        @orders ||= file.orders
      end

      def mod
        metadata['Root']['Mod']
      end

      def version
        metadata['Root']['Version']
      end

      def map_id
        metadata['Root']['MapUid']
      end

      def map_title
        metadata['Root']['MapTitle']
      end

      def start_time
        Time.parse(metadata['Root']['StartTimeUtc'])
      end

      def end_time
        Time.parse(metadata['Root']['EndTimeUtc'])
      end
    end
  end
end
