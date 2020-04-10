# coding: utf-8
require File.expand_path('../lib/openra/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'openra'
  spec.version       = Openra::VERSION
  spec.authors       = ['Andy Holland']
  spec.email         = ['andyholland1991@aol.com']
  spec.summary       = 'Openra Rubygem'
  spec.homepage      = 'https://github.com/AMHOL/openra-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0") - ['bin/console']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler'
  spec.add_dependency 'bindata', '2.4.3'
  spec.add_dependency 'dry-transformer'
  spec.add_dependency 'dry-types', '0.13.2'
  spec.add_dependency 'dry-struct', '0.5.0'
  spec.add_dependency 'hanami-cli', '0.2.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end
