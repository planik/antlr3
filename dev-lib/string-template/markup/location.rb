#!/usr/bin/ruby
module StringTemplate
  module Markup
    Location = Struct.new(:position, :line, :column, :markup_position)

    class Location
      include Comparable

      def to_a
        [position, line, column]
      end

      def to_s
        [line, column].join(':')
      end

      def <<(text)
        length     = text.length
        line_count = text.count("\n")
        if line_count.zero?
          (self.column += length)
        else
          (self.column = length - text.rindex("\n") - 1)
        end
        self.line += line_count
        self.position += length
        self
      end

      def +(other)
        dup << other
      end

      def <=>(other)
        position <=> other.position
      end
    end
  end
end
