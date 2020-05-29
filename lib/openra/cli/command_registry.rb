# frozen_string_literal: true

module Openra
  class CLI
    class CommandRegistry
      extend Dry::CLI::Registry

      register 'replay-data', Commands::ReplayData
      register 'replay-metadata', Commands::ReplayMetadata
      register 'version', Commands::Version
    end
  end
end
