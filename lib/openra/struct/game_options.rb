module Openra
  class Struct < Dry::Struct
    class GameOptions < Openra::Struct
      define do
        attribute :starting_cash, IntegerOption.meta(from: 'startingcash')
        attribute :cheats_enabled, BooleanOption.meta(from: 'cheats')
        attribute :explored_map_enabled, BooleanOption.meta(from: 'explored')
        attribute :fog_enabled, BooleanOption.meta(from: 'fog')
        attribute :bounties_enabled, BooleanOption.meta(from: 'bounty')
        attribute :conyard_undeploy_enabled, BooleanOption.meta(from: 'factundeploy')
        attribute :crates_enabled, BooleanOption.meta(from: 'crates')
        attribute :build_off_allies_enabled, BooleanOption.meta(from: 'allybuild')
        attribute :restricted_build_radius_enabled, BooleanOption.meta(from: 'buildradius')
        attribute :short_game_enabled, BooleanOption.meta(from: 'shortgame')
        attribute :tech_level, StringOption.meta(from: 'techlevel')
        attribute :game_speed, StringOption.meta(from: 'gamespeed')
        attribute :starting_units, StringOption.meta(from: 'startingunits')
      end
    end
  end
end
