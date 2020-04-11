# frozen_string_literal: true

module Openra
  class Struct < Dry::Struct
    class GameOptions < Openra::Struct
      class BooleanOption < Openra::Struct
        define do
          attribute :value, Types::Params::Bool.meta(from: 'Value')
          attribute :preferred_value, Types::Params::Bool.meta(
            from: 'PreferredValue'
          )
        end
      end
    end
  end
end
