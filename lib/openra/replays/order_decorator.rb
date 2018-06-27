class OrderDecorator < SimpleDelegator
  attr_reader :client

  def initialize(order, client)
    @client = client
    super(order)
  end
end
