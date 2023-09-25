#!/usr/bin/ruby
class String
  def here_indent!
    gsub!(/^[ \t]*\|[ \t]?/, '')
    self
  end

  def here_flow!
    here_indent!.gsub!(/\n\s+/, ' ')
    self
  end
end
