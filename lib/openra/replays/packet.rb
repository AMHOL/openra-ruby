module OpenRA
  module Replays
    class Packet < BinData::Record
      endian :little
      uint32 :client
      uint32 :data_length
      string :data, read_length: :data_length

      def order_list
        return unless valid_order_list?
        @order_list ||= OrderList.read(data)
      end

      def orders
        order_list.flat_map(&:orders)
      end

      def valid_order_list?
        !(data.bytesize < 5 ||
          data.bytesize == 5 && data.bytes.last == 0xBF ||
          data.bytesize >= 5 && data.bytes[4] == 0x65)
      end
    end
  end
end
