module Openra
  class CLI
    module Commands
      class ReplayData < Hanami::CLI::Command
        module Formatters
          class JSON
            def call(data)
              ::JSON.dump(data)
            end
          end

          class PrettyJSON
            def call(data)
              ::JSON.pretty_generate(data)
            end
          end

          class YAML
            def call(data)
              ::YAML.dump(
                Openra::Struct::Functions[:deep_stringify_keys].(data)
              )
            end
          end
        end
      end
    end
  end
end
