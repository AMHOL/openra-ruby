# frozen_string_literal: true

module Openra
  class Struct < Dry::Struct
    class GlobalSettings < Openra::Struct
      transform_types(&:omittable)

      define do
        attribute :server_name, Types::Strict::String.meta(from: 'ServerName')
        attribute :map_hash, Types::Strict::String.meta(from: 'Map')
        attribute :timestep, Types::Params::Integer.meta(from: 'Timestep')
        attribute :net_frame_interval, Types::Params::Integer.meta(from: 'NetFrameInterval')
        attribute :order_latency, Types::Params::Integer.meta(
          from: 'OrderLatency'
        )
        attribute :random_seed, Types::Strict::String.meta(from: 'RandomSeed')
        attribute :allow_spectators, Types::Params::Bool.meta(
          from: 'AllowSpectators'
        )
        attribute :allow_version_mismatch, Types::Params::Bool.meta(
          from: 'AllowVersionMismatch')
        attribute :game_id, Types::Strict::String.meta(from: 'GameUid'
        )
        attribute :allow_singleplayer, Types::Params::Bool.meta(
          from: 'EnableSingleplayer'
        )
        attribute :enable_sync_reports, Types::Params::Bool.meta(
          from: 'EnableSyncReports'
        )
        attribute :dedicated, Types::Params::Bool.meta(from: 'Dedicated')
        attribute :save_enabled, Types::Params::Bool.meta(
          from: 'GameSavesEnabled'
        )
        attribute :game_options, GameOptions.meta(from: 'Options')
      end

      def frametime_multiplier
        if timestep
          timestep * 3
        else
          net_frame_interval * 40
        end
      end
    end
  end
end
