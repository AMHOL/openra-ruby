# frozen_string_literal: true

module Openra
  class CLI
    module Commands
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

      FORMATTERS = {
        'json' => Formatters::JSON.new,
        'pretty-json' => Formatters::PrettyJSON.new,
        'yaml' => Formatters::YAML.new,
      }.freeze
    end
  end
end
