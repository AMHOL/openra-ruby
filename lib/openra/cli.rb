# frozen_string_literal: true

require 'yaml'
require 'json'
require 'dry/cli'
require 'openra/version'
require 'openra/commands'
require 'openra/cli/formatters'
require 'openra/cli/commands/replay_data'
require 'openra/cli/commands/replay_metadata'
require 'openra/cli/commands/version'
require 'openra/cli/command_registry'

module Openra
  class CLI
    def call(*args, **kwargs, &block)
      Dry::CLI.new(CommandRegistry).call(*args, **kwargs, &block)
    end
  end
end
