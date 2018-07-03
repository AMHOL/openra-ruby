module Openra
  class CLI
    class CommandRegistry
      extend Hanami::CLI::Registry

      register 'replay-data', Commands::ReplayData
      register 'version', Commands::Version
    end
  end
end
