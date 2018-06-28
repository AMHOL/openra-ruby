module Openra
  module Replays
    class OrderDecorator < SimpleDelegator
      attr_reader :client_index

      def initialize(order, client_index)
        @client_index = client_index
        super(order)
      end
    end
  end
end
