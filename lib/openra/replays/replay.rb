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

        syncs = orders.reverse.each_with_object([]) do |order, arr|
          next unless order.command == 'SyncInfo'

          arr << Openra::Struct::SyncInfo.new(
            Openra::YAML.load(order.target)
          )
        end

        @sync_info = syncs.inject(syncs.shift) do |next_sync, sync|
          next_sync.clients.each do |client|
            next if sync.clients.map(&:index).include?(client.index)
            sync.clients << client
          end

          sync
        end
      end
    end
  end
end
