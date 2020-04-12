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

  spec.files         = Dir[
    'CHANGELOG.md',
    'LICENSE',
    'README.md',
    'openra.gemspec',
    'lib/**/*',
    'bin/openra'
  ]
  spec.bindir        = 'bin'
  spec.executables   = ['openra']
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler'
  spec.add_dependency 'bindata'
  spec.add_dependency 'dry-transformer'
  spec.add_dependency 'dry-types'
  spec.add_dependency 'dry-struct'
  spec.add_dependency 'dry-cli'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
