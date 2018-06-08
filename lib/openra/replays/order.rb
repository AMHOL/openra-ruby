module OpenRA
  module Replays
    class Order < BinData::Record
      HEX_FE = ?\xFE.force_encoding('ASCII-8BIT').freeze
      HEX_FF = ?\xFF.force_encoding('ASCII-8BIT').freeze
      # NEED TO LEARN HOW TO READ FLAGS AND TARGET TYPE
      # IS_STANDARD_ORDER = -> { identifier == HEX_FF }
      # IS_IMMEDIATE_ORDER = -> { identifier == HEX_FE }
      # HAS_TARGET = -> { flags }
      # TARGET_IS_ACTOR = -> { target_type }
      # TARGET_IS_FROZEN_ACTOR = -> { target_type }
      # TARGET_IS_TERRAIN = -> { target_type }
      # TARGET_IS_CELL = -> { TARGET_IS_TERRAIN.() && flags }
      # TARGET_NOT_CELL = -> { !TARGET_IS_CELL.() }
      # HAS_TARGET_STRING = -> { flags }
      # HAS_EXTRA_LOCATION = -> { flags }
      # HAS_EXTRA_DATA = -> { flags }

      # Target = 0x01,
      # TargetString = 0x04,
      # Queued = 0x08,
      # ExtraLocation = 0x10,
      # ExtraData = 0x20,
      # TargetIsCell = 0x40

      endian :little
      # Common
      string :identifier, read_length: 1
      pascal_string :command
      # Immediate Order Data
      pascal_string :target, read_length: :target_length # , onlyif: IS_STANDARD_ORDER
      # Standard Order Data
      # uint32 :subject_id, onlyif: IS_IMMEDIATE_ORDER
      # string :flags, read_length: 1, onlyif: IS_IMMEDIATE_ORDER
      # string :target_type, read_length: 1, onlyif: HAS_TARGET
      # uint32 :actor_id, onlyif: TARGET_IS_ACTOR
      # uint32 :player_actor_id, onlyif: TARGET_IS_FROZEN_ACTOR
      # uint32 :frozen_actor_id, onlyif: TARGET_IS_FROZEN_ACTOR
      # int32 :target_x, onlyif: TARGET_IS_CELL
      # int32 :target_y, onlyif: TARGET_IS_CELL
      # string :target_layer, read_length: 1, onlyif: TARGET_IS_CELL
      # int32 :target_sub_cell, onlyif: TARGET_IS_CELL
      # int32 :pos_x, onlyif: TARGET_NOT_CELL
      # int32 :pos_y, onlyif: TARGET_NOT_CELL
      # int32 :pos_z, onlyif: TARGET_NOT_CELL
      # int32 :target_string_length, onlyif: HAS_TARGET_STRING
      # string :target_string, read_length: :target_string_length, onlyif: HAS_TARGET_STRING
      # int32 :extra_pos_x, onlyif: HAS_EXTRA_LOCATION
      # int32 :extra_pos_y, onlyif: HAS_EXTRA_LOCATION
      # string :extra_pos_layer, read_length: 1, onlyif: HAS_EXTRA_LOCATION
      # uint32 :extra_data, onlyif: HAS_EXTRA_DATA
    end
  end
end
