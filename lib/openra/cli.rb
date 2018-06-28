require 'hanami/cli'
require 'openra'
require 'openra/cli/command_registry'

module Openra
  class CLI
    def call(*args)
      Hanami::CLI.new(CommandRegistry).call(*args)
    end
  end
end
