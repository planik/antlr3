#!/usr/bin/ruby
require 'antlr3'
require 'antlr3/streams/unicode'

require 'test/unit'
require 'spec'

include ANTLR3

class TestUnicodeStream < Test::Unit::TestCase
  def setup
    #   «    a   »    \n  9   8   °    \n
    # [ 171, 97, 187, 10, 57, 56, 176, 10]
    @stream = UnicodeStream.new("«a»\n98°\n")
  end

  def test_size
    @stream.size.should == 8
  end

  def test_index
    @stream.index.should == 0
  end

  def test_consume
    @stream.consume # «
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # a
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # »
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume #  \n
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # 9
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # 8
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # °
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # \n
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # EOF
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # EOF
    @stream.index.should
    @stream.column.should
    @stream.line.should == 3
  end

  def test_reset
    2.times { @stream.consume }
    @stream.reset
    @stream.index.should
    @stream.line.should
    @stream.column.should
    @stream.peek(1).should == 171 # code point for «
  end

  def test_look
    @stream.look(1).should
    @stream.look(2).should
    @stream.look(3).should
    @stream.peek(1).should
    @stream.peek(2).should
    @stream.peek(3).should

    6.times { @stream.consume }
    @stream.look(1).should
    @stream.look(2).should
    @stream.look(3).should be_nil
    @stream.peek(1).should
    @stream.peek(2).should
    @stream.peek(3).should == EOF
  end

  def test_substring
    @stream.substring(0, 0).should
    @stream.substring(0, 1).should
    @stream.substring(0, 10).should
    @stream.substring(3, 6).should == "\n98°"
  end

  def test_seek_forward
    @stream.seek(4)
    @stream.index.should
    @stream.line.should
    @stream.column.should
    @stream.peek(1).should == 57
  end

  def test_mark
    @stream.seek(4)
    marker = @stream.mark
    marker.should

    2.times { @stream.consume }
    marker = @stream.mark

    marker.should == 2
  end

  def test_release_last
    @stream.seek(4)
    marker1 = @stream.mark

    2.times { @stream.consume }
    marker2 = @stream.mark

    @stream.release
    @stream.mark_depth.should
    @stream.release
    @stream.mark_depth.should == 1
  end

  def test_release_nested
    @stream.seek(4)
    marker1 = @stream.mark

    @stream.consume
    marker2 = @stream.mark

    @stream.consume
    marker3 = @stream.mark

    @stream.release(marker2)
    @stream.mark_depth.should == 2
  end

  def test_rewind_last
    @stream.seek(4)

    marker = @stream.mark
    @stream.consume
    @stream.consume

    @stream.rewind
    @stream.mark_depth.should
    @stream.index.should
    @stream.line.should
    @stream.column.should
    @stream.peek(1).should == 57
  end

  def test_through
    @stream.through(2).should
    @stream.through(-2).should
    @stream.seek(4)
    @stream.through(0).should
    @stream.through(1).should
    @stream.through(-2).should
    @stream.through(5).should == "98°\n"
  end
end
