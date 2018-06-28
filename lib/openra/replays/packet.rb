module Openra
  module Replays
    class Packet < BinData::Record
      endian :little
      int32 :client_index
      int32 :data_length
      string :data, read_length: :data_length

      def orders
        return unless valid_order_list?

        order_list = OrderList.read(data)

        @orders ||= order_list.orders.map do |order|
          OrderDecorator.new(order, client_index, order_list.frame)
        end
      end

      def order_list
        return unless valid_order_list?

        @order_list ||= OrderList.read(data)
      end

      def valid_order_list?
        return @valid_order_list if defined?(@valid_order_list)

        @valid_order_list = begin
          !(data.bytesize < 5 ||
            data.bytesize == 5 && data.bytes.last == 0xBF ||
            data.bytesize >= 5 && data.bytes[4] == 0x65)
        end
      end
    end
  end
end
