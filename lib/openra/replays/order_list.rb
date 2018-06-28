module Openra
  module Replays
    class OrderList < BinData::Record
      endian :little
      int32 :frame
      array :orders, type: :order, read_until: :eof
    end
  end
end
