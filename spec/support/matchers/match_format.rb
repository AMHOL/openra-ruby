# frozen_string_literal: true

RSpec::Matchers.define :match_format do |expected|
  formats = {
    'json' => ->(input) { JSON.load(input) },
    'pretty-json' => ->(input) { JSON.load(input) },
    'yaml' => ->(input) { YAML.load(input) }
  }

  match do |actual|
    formatter = formats.fetch(@format)
    @formatted_expected = formatter.(expected)
    @formatted_actual = formatter.(actual)

    expect(@formatted_actual).to eq(@formatted_expected)
  end

  chain :format do |format|
    @format = format
  end

  failure_message do |_|
    "expected #{@formatted_actual} to match #{@formatted_expected}"
  end

  failure_message_when_negated do |_|
    "expected #{@formatted_actual} not to match #{@formatted_expected}"
  end

  diffable
end
