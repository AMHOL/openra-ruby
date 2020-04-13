# frozen_string_literal: true

module Openra
  module Replays
    # The metadata markers is an int32 marker at the end of the file, indicating
    # the offset at which the metadata MiniYAML is stored in the replay file
    class MetadataMarker < BinData::Record
      endian :little
      count_bytes_remaining :total_size
      skip to_abs_offset: -> { total_size - 8 }
      int32 :data_length
    end
  end
end
