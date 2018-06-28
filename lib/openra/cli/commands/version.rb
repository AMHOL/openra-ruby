module Openra
  class CLI
    module Commands
      class Version < Hanami::CLI::Command
        desc 'Print current version number'

        def call(*)
          puts Openra::VERSION
        end
      end
    end
  end
end
