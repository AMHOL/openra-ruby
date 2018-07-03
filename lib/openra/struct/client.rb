module Openra
  class Struct < Dry::Struct
    class Client < Openra::Struct
      define do
        attribute :index, Types::Strict::String.meta(from: 'Index')
        attribute :preferred_color, Types::Strict::String.meta(from: 'PreferredColor')
        attribute :color, Types::Strict::String.meta(from: 'Color')
        attribute :faction_name, Types::Strict::String.meta(from: 'Faction')
        attribute :spawn_point, Types::Strict::String.meta(from: 'SpawnPoint')
        attribute :name, Types::Strict::String.meta(from: 'Name')
        attribute :ip, Types::Strict::String.meta(from: 'IpAddress')
        attribute :state, Types::Strict::String.meta(from: 'State')
        attribute :team, Types::Strict::String.meta(from: 'Team')
        attribute :slot, Types::Strict::String.meta(from: 'Slot')
        attribute :bot_controller_index, Types::Strict::String.meta(
          from: 'BotControllerClientIndex'
        )
        attribute :is_admin, Types::Params::Bool.meta(from: 'IsAdmin')
      end

      def team
        attributes[:team] == '0' ? nil : attributes[:team]
      end
    end
  end
end
