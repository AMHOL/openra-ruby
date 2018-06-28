require 'openra/cli/commands/replay_data'
require 'openra/cli/commands/version'

module Openra
  class CLI
    class CommandRegistry
      extend Hanami::CLI::Registry

      register 'replay-data', Commands::ReplayData
      register 'version', Commands::Version
    end
  end
end
