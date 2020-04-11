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

  spec.files         = `git ls-files -z`.split("\x0") - %w(
    bin/console
    bin/profile
    bin/trace_alloc
  )
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler'
  spec.add_dependency 'bindata'
  spec.add_dependency 'dry-transformer'
  spec.add_dependency 'dry-types'
  spec.add_dependency 'dry-struct'
  spec.add_dependency 'dry-cli'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'memory_profiler'
  spec.add_development_dependency 'stackprof'
end
