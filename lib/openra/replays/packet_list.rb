module OpenRA
  module Replays
    class PacketList < BinData::Record
      endian :little
      array :packets, type: :packet, read_until: :eof

      def orders
        packets.select(&:valid_order_list?).flat_map do |packet|
          packet.order_list.orders
        end
      end
    end
  end
end
