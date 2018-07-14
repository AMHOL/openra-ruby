require 'securerandom'
require 'yaml'
require 'json'
require 'hanami/cli'
require 'openra/version'
require 'openra/replays'
require 'openra/cli/commands/replay_data/formatters'
require 'openra/cli/commands/replay_data'
require 'openra/cli/commands/version'
require 'openra/cli/command_registry'

module Openra
  class CLI
    def call(*args)
      Hanami::CLI.new(CommandRegistry).call(*args)
    end
  end
end
