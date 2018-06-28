# coding: utf-8
require File.expand_path('../lib/openra/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'openra-ruby'
  spec.version       = OpenRA::VERSION
  spec.authors       = ['Andy Holland']
  spec.email         = ['andyholland1991@aol.com']
  spec.summary       = ''
  spec.homepage      = 'https://github.com/AMHOL/openra-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0") - ['bin/console']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bindata'
  spec.add_dependency 'hanami-cli'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
