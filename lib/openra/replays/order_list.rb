module Openra
  module Replays
    class OrderList < BinData::Record
      endian :little
      skip length: 4
      array :orders, type: :order, read_until: :eof
    end
  end
end
