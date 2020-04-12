# frozen_string_literal: true

module Openra
  class Struct < Dry::Struct
    class Player < Openra::Struct
      define do
        attribute :client_index, Types::Strict::String.meta(from: 'ClientIndex')
        attribute :name, Types::Strict::String.meta(from: 'Name')
        attribute :is_human, Types::Params::Bool.meta(from: 'IsHuman')
        attribute :is_bot, Types::Params::Bool.meta(from: 'IsBot')
        attribute :faction_name, Types::Strict::String.meta(from: 'FactionName')
        attribute :faction_id, Types::Strict::String.meta(from: 'FactionId')
        attribute :color, Types::Strict::String.meta(from: 'Color')
        attribute :team, Types::Strict::String.meta(from: 'Team')
        attribute :spawn_point, Types::Strict::String.meta(from: 'SpawnPoint')
        attribute :is_random_faction, Types::Params::Bool.meta(from: 'IsRandomFaction')
        attribute :is_random_spawn, Types::Params::Bool.meta(from: 'IsRandomSpawnPoint')
        attribute :fingerprint, Types::Strict::String.meta(from: 'Fingerprint', omittable: true)
        attribute :outcome, Types::Strict::String.meta(from: 'Outcome')
        attribute :outcome_time, Types::Timestamp.meta(from: 'OutcomeTimestampUtc')
      end

      def team
        attributes[:team] == '0' ? nil : attributes[:team]
      end
    end
  end
end
