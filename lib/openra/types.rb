# frozen_string_literal: true

require 'dry-types'

module Openra
  module Types
    include Dry.Types()

    Timestamp = Constructor(Time) do |input|
      ::DateTime.strptime(input, '%Y-%m-%d %H-%M-%S').to_time
    end

    UTF8String = Types::String.constructor do |input|
      input.force_encoding('UTF-8')
    end
  end
end
