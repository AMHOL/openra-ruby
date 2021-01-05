# frozen_string_literal: true

module Openra
  module Commands
    module Replays
      class ExtractMetadata
        include Utils

        def call(filepath)
          replay = Openra::Replays::Replay.new(filepath)

          {
            mod: replay.metadata.mod,
            version: replay.metadata.version,
            file: {
              hash: replay.file_hash
            },
            map: {
              name: utf8(replay.metadata.map_name),
              hash: replay.metadata.map_hash
            },
            game: {
              type: replay.players.each_with_object(Hash.new(0)) { |player, hash|
                if player.team.nil?
                  hash[SecureRandom.uuid] += 1
                else
                  hash[player.team] += 1
                end
              }.values.join('v'),
              start_time: replay.metadata.start_time.iso8601,
              end_time: replay.metadata.end_time.iso8601,
              duration: time((replay.metadata.end_time - replay.metadata.start_time) * 1000)
            },
            players: replay.players.map { |player|
              {
                player_index: player.client_index,
                name: utf8(player.name),
                fingerprint: player.fingerprint,
                color: player.color,
                spawn: {
                  random: player&.is_random_spawn,
                  point: player.spawn_point
                },
                faction: {
                  random: player&.is_random_faction,
                  chosen: player.faction_name.downcase,
                  actual: player&.faction_id
                },
                team: player&.team,
                is_bot: player&.is_bot || false,
                is_winner: player&.outcome == 'Won',
                outcome_time: player.outcome_time.iso8601
              }
            }
          }
        end
      end
    end
  end
end
