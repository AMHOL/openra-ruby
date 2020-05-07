# frozen_string_literal: true

module Openra
  class CLI
    class CommandRegistry
      extend Dry::CLI::Registry

      register 'metadata', Commands::Metadata
      register 'replay-data', Commands::ReplayData
      register 'version', Commands::Version
    end
  end
end
