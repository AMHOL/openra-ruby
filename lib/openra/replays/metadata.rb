# frozen_string_literal: true

module Openra
  module Replays
    class Metadata < BinData::Record
      endian :little
      count_bytes_remaining :total_size
      # -8 to remove metadata marker (int32)
      string :data, length: -> { total_size - 8 }
    end
  end
end
