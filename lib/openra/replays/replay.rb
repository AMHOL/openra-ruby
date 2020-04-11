# frozen_string_literal: true

module Openra
  module Replays
    class Replay
      attr_reader :file

      def initialize(filename)
        @file = Openra::Replays::File.new(filename)
      end

      def metadata
        @metadata ||= Openra::Struct::Metadata.new(
          Openra::YAML.load(file.metadata.data)
        )
      end

      def each_order(&block)
        file.each_order(&block)
      end

      def players
        metadata.players
      end

      def player(index)
        players.find do |candidate|
          candidate.index == index
        end
      end
    end
  end
end
