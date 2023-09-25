#!/usr/bin/env ruby
__DIR__ = File.dirname(__FILE__)
load File.join(__DIR__, 'script-helper.rb')

require 'highline/import'
require 'string-template'

Version = Struct.new(:major, :minor, :patch) do
  def initialize(vstr)
    super(*vstr.split('.', 3).map! { |i| i.to_i })
  end

  def increment!(level = :patch)
    member = members.map { |m| m.to_s }.index(level.to_s)
    self[member] += 1
    for sub in members[member + 1..-1]
      self[sub] = 0
    end
    self
  end

  def increment(level = :patch)
    dup.increment!(level)
  end

  def to_s
    to_a.join('.')
  end
end

$files = {}
def update_file(path)
  path = $project.path(path)
  source = File.read(path)

  $files[path] = yield(source)
end

def write!
  written = {}
  for file, source in $files
    begin
      backup = file + '~'
      File.rename(file, backup)
      written[file] = backup
      open(file, 'w') { |io| io.write(source) }
      puts("updated #{file}")
    rescue Exception
      for orig, back in written
        test('f', back) and File.rename(back, orig)
        warn("restored #{orig} from #{back}")
      end
      raise
    end
  end
end

current_version = Version.new($project.version)
next_version =
  choose do |menu|
    Version.members.each do |m|
      hypothetical_version = current_version.increment(m)
      menu.choice("#{m} (#{hypothetical_version})") { hypothetical_version }
    end
  end

update_file('config/$(name).yaml') do |source|
  now = %(version: "#{current_version}")
  new = %(version: "#{next_version}")
  source[now] = new
  source
end

update_file('lib/$(name)/version.rb') do |source|
  current_version.each_pair do |level, value|
    rx = /^(\s*)#{level.to_s.upcase}_VERSION\s*=\s*#{value}$/
    source =~ rx or raise("can't find a line matching %p in version.rb" % rx)
    old_line = $~[0]
    new_line = "#{Regexp.last_match(1)}#{level.to_s.upcase}_VERSION = #{next_version[level]}"
    source[old_line] = new_line
  end
  source
end

update_file('templates/Ruby.stg') do |source|
  source.sub(
    /runtimeLibraryVersion\(\) ::= ".*?"/,
    %(runtimeLibraryVersion() ::= "#{next_version}")
  )
end

write!
