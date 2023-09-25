#!/usr/bin/ruby
class String
  def /(other)
    File.join(self, other.to_s)
  end
end
