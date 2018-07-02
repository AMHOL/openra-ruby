module Openra
  class Struct < Dry::Struct
    class GameOptions < Openra::Struct
      class StringOption < Openra::Struct
        define do
          attribute :value, Types::Strict::String.meta(from: 'Value')
          attribute :preferred_value, Types::Strict::String.meta(
            from: 'PreferredValue'
          )
        end
      end
    end
  end
end
