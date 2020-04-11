# frozen_string_literal: true

module Openra
  class Struct < Dry::Struct
    class GameOptions < Openra::Struct
      class IntegerOption < Openra::Struct
        define do
          attribute :value, Types::Params::Integer.meta(from: 'Value')
          attribute :preferred_value, Types::Params::Integer.meta(
            from: 'PreferredValue'
          )
        end
      end
    end
  end
end
