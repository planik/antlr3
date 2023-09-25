#!/usr/bin/ruby
SourceNote = Struct.new(:tag, :file, :line, :text) do
  def self.scan(tags, paths)
    block_given? or return enum_for(:scan, tags, paths)
    (tags = [tags]).flatten!
    tags = Regexp.union(*tags)
    tag_pattern = /\b(#{tags})\b:? *(.*?)$/o

    for path in paths
      open(path) do |file|
        file.grep(tag_pattern) do
          yield(SourceNote[Regexp.last_match(1), File.relative(path), file.lineno, Regexp.last_match(2)])
        end
      end
    end
  end

  def colorize(color_map)
    each_pair.map do |field, value|
      color = color_map[field]
      color ? value.to_s.send(color) : value
    end
  end

  def to_s(color_map = nil)
    tag, file, line, text = colorize(color_map) if color_map
    format('%s:%03i:%s: %s', file, line, tag, text)
  end
end
