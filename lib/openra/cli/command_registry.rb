module Openra
  class CLI
    class CommandRegistry
      extend Dry::CLI::Registry

      register 'replay-data', Commands::ReplayData
      register 'detect-production-macros', Commands::DetectProductionMacros
      register 'version', Commands::Version
    end
  end
end
