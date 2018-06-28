require 'openra/cli/commands/replay_data'

module Openra
  class CLI
    class CommandRegistry
      extend Hanami::CLI::Registry

      register 'replay-data', Commands::ReplayData
    end
  end
end
