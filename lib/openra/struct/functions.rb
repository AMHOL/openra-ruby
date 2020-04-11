# frozen_string_literal: true

module Openra
  class Struct < Dry::Struct
    module Functions
      extend Dry::Transformer::Registry

      import Dry::Transformer::HashTransformations

      def self.sequence(hash, prefix, into)
        keys = hash.keys.select { |key| key.start_with?(prefix + '@') }

        hash[into] = keys.map { |key| hash[key] }

        hash
      end

      def self.deep_stringify_keys(hash)
        hash.each_with_object({}) do |(key, value), output|
          output[key.to_s] =
            case value
            when Hash
              deep_stringify_keys(value)
            when Array
              value.map { |item|
                item.is_a?(Hash) ? deep_stringify_keys(item) : item
              }
            else
              value
            end
        end
      end
    end
  end
end
