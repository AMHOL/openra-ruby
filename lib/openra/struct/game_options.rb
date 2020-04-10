module Openra
  class Struct < Dry::Struct
    class GameOptions < Openra::Struct
      define do
        attribute :starting_cash, IntegerOption.meta(from: 'startingcash')
        attribute :cheats_enabled, BooleanOption.meta(from: 'cheats')
        attribute :explored_map_enabled, BooleanOption.meta(from: 'explored')
        attribute :fog_enabled, BooleanOption.meta(from: 'fog')
        attribute :bounties_enabled, BooleanOption.meta(from: 'bounty', omittable: true)
        attribute :conyard_undeploy_enabled, BooleanOption.meta(from: 'factundeploy', omittable: true)
        attribute :crates_enabled, BooleanOption.meta(from: 'crates')
        attribute :build_off_allies_enabled, BooleanOption.meta(from: 'allybuild')
        attribute :restricted_build_radius_enabled, BooleanOption.meta(from: 'buildradius', omittable: true)
        attribute :short_game_enabled, BooleanOption.meta(from: 'shortgame')
        attribute :reusable_engineers, BooleanOption.meta(from: 'reusable-engineers', omittable: true)
        attribute :tech_level, StringOption.meta(from: 'techlevel')
        attribute :game_speed, StringOption.meta(from: 'gamespeed')
        attribute :starting_units, StringOption.meta(from: 'startingunits')
        attribute :separate_team_spawns, StringOption.meta(from: 'separateteamspawns', omittable: true)
      end

      def bounties_enabled
        attributes.fetch(:bounties_enabled, BooleanOption.new(
          value: true,
          preferred_value: true
        ))
      end

      def conyard_undeploy_enabled
        attributes.fetch(:conyard_undeploy_enabled, BooleanOption.new(
          value: true,
          preferred_value: true
        ))
      end

      def restricted_build_radius_enabled
        attributes.fetch(:restricted_build_radius_enabled, BooleanOption.new(
          value: true,
          preferred_value: true
        ))
      end
    end
  end
end
