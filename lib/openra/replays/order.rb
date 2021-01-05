# frozen_string_literal: true

module Openra
  module Replays
    # https://github.com/OpenRA/OpenRA/blob/bleed/OpenRA.Game/Network/Order.cs
    class Order < BinData::Record
      HEX_FE = ?\xFE.dup.force_encoding('ASCII-8BIT').freeze
      HEX_FF = ?\xFF.dup.force_encoding('ASCII-8BIT').freeze

      IS_STANDARD_ORDER = -> { order_type == HEX_FF }
      IS_IMMEDIATE_ORDER = -> { order_type == HEX_FE }
      HAS_TARGET = -> { instance_exec(&IS_STANDARD_ORDER) && (flags & 0x01) == 0x01 }
      HAS_EXTRA_ACTORS = -> { instance_exec(&IS_STANDARD_ORDER) && (flags & 0x02) == 0x02 }
      TARGET_IS_ACTOR = -> { instance_exec(&HAS_TARGET) && target_type == 1 }
      TARGET_IS_TERRAIN = -> { instance_exec(&HAS_TARGET) && target_type == 2 }
      TARGET_IS_FROZEN_ACTOR = -> { instance_exec(&HAS_TARGET) && target_type == 3 }
      TARGET_IS_CELL = -> { instance_exec(&TARGET_IS_TERRAIN) && (flags & 0x40) == 0x40 }
      TARGET_NOT_CELL = -> { instance_exec(&TARGET_IS_TERRAIN) && (flags & 0x40) != 0x40 }
      HAS_SUBJECT = -> { instance_exec(&IS_STANDARD_ORDER) && (flags & 0x80) == 0x80 }
      HAS_TARGET_STRING = -> { instance_exec(&IS_STANDARD_ORDER) && (flags & 0x04) == 0x04 }
      HAS_EXTRA_LOCATION = -> { instance_exec(&IS_STANDARD_ORDER) && (flags & 0x10) == 0x10 }
      HAS_EXTRA_DATA = -> { instance_exec(&IS_STANDARD_ORDER) && (flags & 0x20) == 0x20 }
      # IS_QUEUED = -> { instance_exec(&IS_STANDARD_ORDER) && (flags & 0x08) == 0x08 }
      IS_GROUPED = -> { instance_exec(&IS_STANDARD_ORDER) && (flags & 0x100) == 0x100 }

      endian :little
      # Common
      string :order_type, read_length: 1
      pascal_string :command # order in protocol
      # Immediate Order Data
      pascal_string :immediate_order_target, onlyif: IS_IMMEDIATE_ORDER
      # Standard Order Data
      int16 :flags, onlyif: IS_STANDARD_ORDER
      uint32 :subject_id, onlyif: HAS_SUBJECT
      uint8 :target_type, onlyif: HAS_TARGET
      uint32 :actor_id, onlyif: TARGET_IS_ACTOR
      uint32 :player_actor_id, onlyif: TARGET_IS_FROZEN_ACTOR
      uint32 :frozen_actor_id, onlyif: TARGET_IS_FROZEN_ACTOR
      int32 :target_cell, onlyif: TARGET_IS_CELL
      uint8 :target_sub_cell, onlyif: TARGET_IS_CELL
      int32 :pos_x, onlyif: TARGET_NOT_CELL
      int32 :pos_y, onlyif: TARGET_NOT_CELL
      int32 :pos_z, onlyif: TARGET_NOT_CELL
      pascal_string :standard_order_target, onlyif: HAS_TARGET_STRING
      int32 :extra_actors_count, onlyif: HAS_EXTRA_ACTORS
      array :extra_actor_ids, type: :uint32, initial_length: :extra_actors_count, onlyif: HAS_EXTRA_ACTORS
      int32 :extra_cell, onlyif: HAS_EXTRA_LOCATION
      uint32 :extra_data, onlyif: HAS_EXTRA_DATA
      int32 :grouped_actors_count, onlyif: IS_GROUPED
      array :grouped_actor_ids, type: :uint32, initial_length: :grouped_actors_count, onlyif: IS_GROUPED

      def target
        standard? ? standard_order_target : immediate_order_target
      end

      def type
        case order_type
        when HEX_FF
          :standard
        when HEX_FE
          :immediate
        end
      end

      def standard?
        type == :standard
      end

      def immediate?
        type == :immediate
      end

      def queued?
        flags & 8 == 8
      end
    end
  end
end
