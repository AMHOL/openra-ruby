require 'dry/transformer/all'
require 'dry-struct'
require 'openra/types'
require 'openra/struct/functions'
require 'openra/struct/pre_processor'

module Openra
  class Struct < Dry::Struct
    UNDEFINED = Object.new.freeze
    DEFAULT_PROCESSOR = PreProcessor.new

    class << self
      def preprocessor(processor = UNDEFINED)
        if processor === UNDEFINED
          @__preprocessor || DEFAULT_PROCESSOR
        else
          @__preprocessor = processor
        end
      end

      def inherited(subclass)
        super
        subclass.preprocessor(preprocessor)
      end

      def define(&block)
        instance_eval(&block)

        preprocessor(preprocessor.with(**{ schema: schema }))

        preprocessor.finalize!
      end

      def new(attributes)
        super(preprocessor.call(attributes))
      end
    end
  end
end

require 'openra/struct/client'
require 'openra/struct/player'
require 'openra/struct/game_options/boolean_option'
require 'openra/struct/game_options/integer_option'
require 'openra/struct/game_options/string_option'
require 'openra/struct/game_options'
require 'openra/struct/global_settings'
require 'openra/struct/sync_info'
require 'openra/struct/sync_lobby_clients'
require 'openra/struct/metadata'
