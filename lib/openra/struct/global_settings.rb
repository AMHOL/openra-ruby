module Openra
  class Struct < Dry::Struct
    class GlobalSettings < Openra::Struct
      define do
        attribute :server_name, Types::Strict::String.meta(from: 'ServerName')
        attribute :map_hash, Types::Strict::String.meta(from: 'Map')
        attribute :timestep, Types::Params::Integer.meta(from: 'Timestep')
        attribute :order_latency, Types::Params::Integer.meta(from: 'OrderLatency')
        attribute :random_seed, Types::Strict::String.meta(from: 'RandomSeed')
        attribute :allow_spectators, Types::Params::Bool.meta(from: 'AllowSpectators')
        attribute :allow_version_mismatch, Types::Params::Bool.meta(
          from: 'AllowVersionMismatch',
          omittable: true
        )
        attribute :game_id, Types::Strict::String.meta(from: 'GameUid')
        attribute :allow_singleplayer, Types::Params::Bool.meta(from: 'EnableSingleplayer')
        attribute :enable_sync_reports, Types::Params::Bool.meta(from: 'EnableSyncReports', omittable: true)
        attribute :dedicated, Types::Params::Bool.meta(from: 'Dedicated', omittable: true)
        attribute :save_enabled, Types::Params::Bool.meta(from: 'GameSavesEnabled', omittable: true)
        attribute :game_options, GameOptions.meta(from: 'Options')
      end

      def frametime_multiplier
        timestep * order_latency
      end
    end
  end
end
