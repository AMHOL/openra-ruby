module OpenRA
  module Replays
    class MetadataMarker < BinData::Record
      endian :little
      count_bytes_remaining :total_size
      skip to_abs_offset: -> { total_size - 8 }
      int32 :data_length
    end
  end
end
