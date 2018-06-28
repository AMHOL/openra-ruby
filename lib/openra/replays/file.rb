module OpenRA
  module Replays
    class File
      def initialize(filename)
        @filename = filename
      end

      def packets
        @packets ||= PacketList.read(fs)
      end

      def orders
        @orders ||= packets.orders
      end

      def metadata
        metadata_fs = fs
        offset = -(metadata_marker.data_length + 4)
        metadata_fs.seek(offset, IO::SEEK_END)

        @metadata ||= Metadata.read(metadata_fs)
      end


      private

      attr_reader :filename

      def fs
        @fs ||= ::File.open(filename, 'rb')
        @fs.tap(&:rewind)
      end

      def metadata_marker
        @metadata_marker ||= MetadataMarker.read(fs)
      end
    end
  end
end
