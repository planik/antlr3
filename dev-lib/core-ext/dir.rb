#!/usr/bin/ruby
class Dir
  DOTS = %w[. ..].freeze
  def self.children(directory)
    entries = Dir.entries(directory) - DOTS
    entries.map! do |entry|
      File.join(directory, entry)
    end
  end

  def self.mkpath(path)
    $VERBOSE and warn('INFO: Dir.mkpath(%p)' % path)
    test('d', path) and return(path)
    parent = File.dirname(path)
    test('d', parent) or mkpath(parent)
    Dir.mkdir(path)
    path
  end
end
