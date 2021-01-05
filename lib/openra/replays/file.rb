# frozen_string_literal: true

module Openra
  module Replays
    class File
      def initialize(filename)
        @filename = filename
      end

      def each_order(&block)
        return enum_for(:each_order) unless block_given?

        file.rewind

        io = BinData::IO::Read.new(file)
        template = Packet.new(fields: Packet.fields)

        loop do
          begin
            template.new.read(file).orders.each(&block)
          rescue EOFError, IOError
            break
          end
        end
      end

      def generate_hash
        Digest::SHA256.hexdigest(file.read)
      end

      def metadata
        # https://github.com/OpenRA/OpenRA/blob/23b3c237b7071fd308c4664b0b6c5d719c0f3c74/OpenRA.Game/FileFormats/ReplayMetadata.cs#L96
        @metadata ||= begin
          io = file.tap(&:rewind)
          metadata_offset = -(metadata_marker.data_length + 4)
          io.seek(metadata_offset, IO::SEEK_END)
          Metadata.read(io)
        end
      end

      private

      attr_reader :filename

      def file
        @file ||= ::File.open(filename, 'rb')
      end

      def metadata_marker
        @metadata_marker ||= MetadataMarker.read(file)
      end
    end
  end
end
