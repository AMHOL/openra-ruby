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

      def orders
        @orders ||= file.orders
      end

      def players
        metadata.players
      end

      def player(index)
        players.find do |candidate|
          candidate.index == index
        end
      end

      def clients
        sync_info.clients
      end

      def client(index)
        clients.find do |candidate|
          candidate.index == index
        end
      end

      def global_settings
        sync_info.global_settings
      end

      def frametime_multiplier
        global_settings.frametime_multiplier
      end

      def game_options
        global_settings.game_options
      end

      private

      def sync_info
        return @sync_info if @sync_info

        start_game_order = orders.find { |order| order[:command] == 'StartGame' }
        start_game_index = orders.index(start_game_order)
        start_game_sync_order = orders[start_game_index.pred]

        @sync_info = Openra::Struct::SyncInfo.new(
          Openra::YAML.load(start_game_sync_order.target)
        )
      end
    end
  end
end
