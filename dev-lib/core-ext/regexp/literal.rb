#!/usr/bin/ruby
#      ::about::
# author:     Kyle Yetter <kcy5b@yahoo.com>
# created on: June 07, 2009
# purpose:    core extension
# summary:    adds new Regexp.literal constructor
# modifies:   Regexp

class Regexp
  def self.literal(string, options = 0)
    Regexp.new(Regexp.escape(string.to_s), options)
  end
end

__END__

