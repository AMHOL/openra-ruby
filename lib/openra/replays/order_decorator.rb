module Openra
  module Replays
    class OrderDecorator < SimpleDelegator
      attr_reader :client_index, :frame

      def initialize(order, client_index, frame)
        @client_index = client_index
        @frame = frame
        super(order)
      end
    end
  end
end
