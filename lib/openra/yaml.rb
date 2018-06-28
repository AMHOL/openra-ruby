module Openra
  class YAML
    MATCHER = /(?<indentation>\t+)?(?<key>[^\:]+)?\:?\s?(?<value>.+)?/.freeze

    def self.load(yaml_string)
      last_indentation = -1
      last_key = nil
      data = {}
      structs = []

      yaml_string.split("\n").inject(data) do |struct, line|
        next if line =~ /^\s+$/

        matchdata = line.match(MATCHER)
        indentation = matchdata[:indentation].to_s.bytesize
        key = matchdata[:key]
        value = matchdata[:value]

        if indentation > last_indentation
          struct[last_key] = {}
          structs.push(struct[last_key])
          struct = struct[last_key]
        elsif indentation < last_indentation
          diff = last_indentation - indentation
          structs = structs.slice(0..-diff.next)
          struct = structs.last
        end

        struct[key] = value unless key.nil? || value.nil?

        last_key = key
        last_indentation = indentation
        struct
      end

      data[nil]
    end
  end
end
