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
          template.new.read(file).orders.each(&block)
        rescue EOFError, IOError
          break
        end
      end

      def metadata
        @metadata ||= begin
          metadata_fs = file.tap(&:rewind)
          offset = -(metadata_marker.data_length + 4)
          metadata_fs.seek(offset, IO::SEEK_END)
          Metadata.read(metadata_fs)
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
