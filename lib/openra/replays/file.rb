module OpenRA
  module Replays
    class File
      def initialize(filename)
        @filename = filename
      end

      def packets
        @packets ||= PacketList.read(
          ::File.open(filename, 'rb')
        )
      end

      def orders
        packets.orders
      end

      private

      attr_reader :filename
    end
  end
end
