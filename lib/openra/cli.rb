# frozen_string_literal: true

require 'securerandom'
require 'yaml'
require 'json'
require 'dry/cli'
require 'openra/version'
require 'openra/constants'
require 'openra/replays'
require 'openra/cli/commands/formatters'
require 'openra/cli/commands/detect_production_macros'
require 'openra/cli/commands/replay_data'
require 'openra/cli/commands/version'
require 'openra/cli/command_registry'

module Openra
  class CLI
    def call(*args, **kwargs, &block)
      Dry::CLI.new(CommandRegistry).call(*args, **kwargs, &block)
    end
  end
end
