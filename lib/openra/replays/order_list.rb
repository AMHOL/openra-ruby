module OpenRA
  module Replays
    class OrderList < BinData::Record
      endian :little
      uint32 :data_length
      skip length: 4
      string :data, read_length: :data_length
      # array type: :order, read_until: :eof

      def orders
        Order.read(data)
      end
    end
  end
end
