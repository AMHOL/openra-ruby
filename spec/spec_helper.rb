# frozen-string-literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'

  SimpleCov.start do
    minimum_coverage 90
    maximum_coverage_drop 2
    add_filter %r{^/spec/}
  end
end

require 'pathname'
require 'bundler/setup'

SPEC_ROOT = root = Pathname(__FILE__).dirname

begin
  require 'pry'
  require 'pry-byebug'
rescue LoadError
end

require 'openra/cli'

Dir[root.join('support/*.rb').to_s].each do |f|
  require f
end

Dir[root.join('shared/**/*.rb').to_s].each do |f|
  require f
end
