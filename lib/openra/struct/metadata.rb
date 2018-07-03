module Openra
  class Struct < Dry::Struct
    class Metadata < Openra::Struct
      preprocessor(preprocessor.with(root: 'Root'))

      define do
        attribute :mod, Types::Strict::String.meta(from: 'Mod')
        attribute :version, Types::Strict::String.meta(from: 'Version')
        attribute :map_hash, Types::Strict::String.meta(from: 'MapUid')
        attribute :map_name, Types::Strict::String.meta(from: 'MapTitle')
        attribute :start_time, Types::Timestamp.meta(from: 'StartTimeUtc')
        attribute :end_time, Types::Timestamp.meta(from: 'EndTimeUtc')
        attribute :players, Types::Strict::Array.of(Player).meta(sequence: 'Player')
      end
    end
  end
end
