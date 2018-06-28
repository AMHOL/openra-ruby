module Openra
  module Replays
    class Metadata < BinData::Record
      endian :little
      count_bytes_remaining :total_size
      string :data, length: -> { total_size - 8 }
    end
  end
end
