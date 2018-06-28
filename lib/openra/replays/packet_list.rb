module Openra
  module Replays
    class PacketList < BinData::Record
      endian :little
      array :packets, type: :packet, read_until: :eof

      def orders
        @orders ||= packets.select(&:valid_order_list?).flat_map(&:orders)
      end
    end
  end
end
