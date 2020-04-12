# frozen_string_literal: true

class Fixtures
  attr_reader :files

  def self.output_for(file, format)
    File.read(file.sub('/input/', '/output/').sub('.orarep', ".#{format}"))
  end

  def self.mod_for(file)
    file.include?('ra') ? 'ra' : 'cnc'
  end

  def self.release_for(file)
    File.basename(file, '.orarep')
  end

  def initialize(path)
    @files = Dir[SPEC_ROOT.join('fixtures', path)]
  end

  def each(&block)
    files.each(&block)
  end
end
