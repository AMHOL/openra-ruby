module Openra
  class Struct < Dry::Struct
    class PreProcessor
      AlreadyFinalizedError = Class.new(StandardError)
      NotFinalizedError = Class.new(StandardError)

      attr_reader :config

      def initialize(**config)
        @config = config
      end

      def call(input)
        transformer.call(input)
      end

      def with(**new_config)
        raise AlreadyFinalizedError, 'transformer already finalized' if finalized?
        self.class.new(**config.merge(new_config))
      end

      def finalize!
        config = self.config

        transformer_klass = Class.new(Dry::Transformer::Pipe[Functions])
        transformer_klass.instance_eval do
          define! do
            unwrap(config[:root]) if config[:root]

            if (schema = config[:schema])
              schema.keys.each do |key|
                if (sequence = key.type.meta[:sequence])
                  sequence(sequence, sequence)
                  rename_keys(sequence => key.name)
                end
              end

              mapping = schema.keys.each_with_object({}) do |key, mapping|
                mapping[key.type.meta[:from]] = key.name if key.type.meta[:from]
              end

              rename_keys(mapping)
            end
          end
        end

        @transformer = transformer_klass.new
        @finalized = true
      end

      private

      def transformer
        if finalized?
          @transformer
        else
          raise(
            NotFinalizedError,
            'preprocessor must be finalized before being used'
          )
        end
      end

      def finalized?
        @finalized == true
      end
    end
  end
end
