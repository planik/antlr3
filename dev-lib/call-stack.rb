#!/usr/bin/ruby

unless defined? Call

  Call = Struct.new(:file, :line, :method)
  class Call
    def self.parse(call_string)
      parts = call_string.split(':', 3)
      file = parts.shift
      line = parts.shift.to_i
      return Call.new(file, line) if parts.empty?

      mstring = parts.shift
      match = mstring.match(/`(.+)'/)
      method = match ? match[1] : nil
      Call.new(file, line, method)
    end

    def self.convert_backtrace(trace)
      trace.map { |c| parse(c) }
    end

    def irb?
      file == '(irb)'
    end

    def e_switch?
      file == '-e'
    end

    def to_s
      string = format('%s:%i', file, line)
      method and string << ":in `%s'" % method
      string
    end

    def inspect = to_s.inspect
  end # class Call

  module Kernel
    def call_stack(depth = 1)
      Call.convert_backtrace(caller(depth + 1))
    end
  end

  class Exception
    def backtrace!
      Call.convert_backtrace(backtrace)
    end
  end

end # unless defined? Call

__END__
