module OpenRA
  module Replays
    class Replay
      attr_reader :file

      def initialize(filename)
        @file = OpenRA::Replays::File.new(filename)
      end

      def metadata
        @metadata ||= Openra::YAML.load(file.metadata.data)
      end

      def orders
        @orders ||= file.orders
      end

      def mod
        @mod ||= metadata['Root']['Mod']
      end

      def version
        @version ||= metadata['Root']['Version']
      end

      def map_id
        @map_id ||= metadata['Root']['MapUid']
      end

      def map_title
        @map_title ||= metadata['Root']['MapTitle']
      end

      def start_time
        @start_time ||= DateTime.strptime(
          metadata['Root']['StartTimeUtc'],
          '%Y-%m-%d %H-%M-%S'
        ).to_time
      end

      def end_time
        @end_time ||= DateTime.strptime(
          metadata['Root']['EndTimeUtc'],
          '%Y-%m-%d %H-%M-%S'
        ).to_time
      end

      def duration
        @duration ||= (end_time - start_time).to_i
      end
    end
  end
end
