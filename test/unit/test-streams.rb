#!/usr/bin/ruby
require 'antlr3'
require 'test/unit'
require 'spec'

include ANTLR3

class TestStringStream < Test::Unit::TestCase
  def setup
    @stream = StringStream.new("oh\nhey!\n")
  end

  def test_size
    @stream.size.should == 8
  end

  def test_index
    @stream.index.should == 0
  end

  def test_consume
    @stream.consume # o
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # h
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # \n
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume #  h
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # e
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # y
    @stream.index.should
    @stream.column.should
    @stream.line.should

    @stream.consume # !
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
    @stream.peek(1).should == 'o'.ord
  end

  def test_look
    @stream.look(1).should
    @stream.look(2).should
    @stream.look(3).should
    @stream.peek(1).should
    'o'.ord
    @stream.peek(2).should
    'h'.ord
    @stream.peek(3).should
    "\n".ord

    6.times { @stream.consume }
    @stream.look(1).should
    @stream.look(2).should
    @stream.look(3).should be_nil
    @stream.peek(1).should
    '!'.ord
    @stream.peek(2).should
    "\n".ord
    @stream.peek(3).should == EOF
  end

  def test_substring
    @stream.substring(0, 0).should
    @stream.substring(0, 1).should
    @stream.substring(0, 8).should
    @stream.substring(3, 6).should == 'hey!'
  end

  def test_seek_forward
    @stream.seek(3)
    @stream.index.should
    @stream.line.should
    @stream.column.should
    @stream.peek(1).should == 'h'.ord
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
    @stream.peek(1).should == 'e'.ord
  end

  def test_through
    @stream.through(2).should
    @stream.through(-2).should
    @stream.seek(5)
    @stream.through(0).should
    @stream.through(1).should
    @stream.through(-2).should
    @stream.through(5).should == "y!\n"
  end

  def test_rewind_nested
    @stream.seek(4)
    marker1 = @stream.mark

    @stream.consume
    marker2 = @stream.mark

    @stream.consume
    marker3 = @stream.mark

    @stream.rewind(marker2)
    @stream.mark_depth.should
    @stream.index.should
    @stream.line.should
    @stream.column.should
    @stream.peek(1).should == 'y'.ord
  end
end

class TestFileStream < Test::Unit::TestCase
  def test_no_encoding
    path = File.join(File.dirname(__FILE__), 'sample-input/file-stream-1')
    @stream = FileStream.new(path)

    @stream.seek(4)
    marker1 = @stream.mark

    @stream.consume
    marker2 = @stream.mark

    @stream.consume
    marker3 = @stream.mark

    @stream.rewind(marker2)
    @stream.index.should
    @stream.line.should
    @stream.column.should
    @stream.mark_depth.should
    @stream.look(1).should
    @stream.peek(1).should == 'a'.ord
  end
end

class TestCommonTokenStream < Test::Unit::TestCase
  class MockSource
    include ANTLR3::TokenSource
    attr_accessor :tokens

    def initialize
      @tokens = []
    end

    def next_token
      @tokens.shift
    end
  end

  # vvvvvvvv tests vvvvvvvvv
  def test_init
    @source = MockSource.new
    @stream = CommonTokenStream.new(@source)
    @stream.position.should == 0
  end

  def test_rebuild
    @source1 = MockSource.new
    @source2 = MockSource.new
    @source2.tokens << new_token(10, channel: ANTLR3::HIDDEN) << new_token(11)
    @stream = CommonTokenStream.new(@source1)

    @stream.position.should
    @stream.tokens.length.should

    @stream.rebuild(@source2)
    @stream.token_source.should
    @stream.position.should
    @stream.tokens.should have(2).things
  end

  def test_look_empty_source
    @source = MockSource.new
    @stream = CommonTokenStream.new(@source)
    @stream.look.should == ANTLR3::EOF_TOKEN
  end

  def test_look1
    @source = MockSource.new
    @source.tokens << new_token(12)
    @stream = CommonTokenStream.new(@source)
    @stream.look(1).type.should == 12
  end

  def test_look1_with_hidden
    # FIX
    @source = MockSource.new
    @source.tokens << new_token(12, channel: ANTLR3::HIDDEN_CHANNEL) <<
      new_token(13)
    @stream = CommonTokenStream.new(@source)
    @stream.look(1).type.should == 13
  end

  def test_look2_beyond_end
    @source = MockSource.new
    @source.tokens << new_token(12) <<
      new_token(13, channel: ANTLR3::HIDDEN_CHANNEL)

    @stream = CommonTokenStream.new(@source)
    @stream.look(2).type.should == EOF
  end

  def test_look_negative
    @source = MockSource.new
    @source.tokens << new_token(12) << new_token(13)
    @stream = CommonTokenStream.new(@source)
    @stream.consume

    @stream.look(-1).type.should == 12
  end

  def test_lb1
    @source = MockSource.new
    @source.tokens << new_token(12) << new_token(13)
    @stream = CommonTokenStream.new(@source)

    @stream.consume
    @stream.look(-1).type.should == 12
  end

  def test_look_zero
    # FIX
    @source = MockSource.new
    @source.tokens << new_token(12) << new_token(13)
    @stream = CommonTokenStream.new(@source)
    @stream.look(0).should.nil?
  end

  def test_lb_beyond_begin
    @source = MockSource.new
    @source.tokens << new_token(10) <<
      new_token(11, channel: HIDDEN_CHANNEL) <<
      new_token(12, channel: HIDDEN_CHANNEL) <<
      new_token(13)
    @stream = CommonTokenStream.new(@source)

    @stream.look(-1).should
    2.times { @stream.consume }
    @stream.look(-3).should.nil?
  end

  def test_fill_buffer
    @source = MockSource.new
    @source.tokens << new_token(12) << new_token(13) << new_token(14) << new_token(EOF)
    @stream = CommonTokenStream.new(@source)

    @stream.instance_variable_get(:@tokens).length.should
    @stream.tokens[0].type.should
    @stream.tokens[1].type.should
    @stream.tokens[2].type.should == 14
  end

  def test_consume
    @source = MockSource.new
    @source.tokens << new_token(12) << new_token(13) << new_token(EOF)
    @stream = CommonTokenStream.new(@source)
    @stream.peek.should
    @stream.consume
    @stream.peek.should
    @stream.consume
    @stream.peek.should
    @stream.consume
    @stream.peek.should == EOF
  end

  def test_seek
    @source = MockSource.new
    @source.tokens << new_token(12) << new_token(13) << new_token(EOF)
    @stream = CommonTokenStream.new(@source)

    @stream.peek(1).should
    @stream.seek(2).peek.should
    @stream.seek(0).peek.should
    @stream.seek(-3).position.should
    @stream.seek(10).position.should == 2
  end

  def test_mark_rewind
    @source = MockSource.new
    @source.tokens << new_token(12) << new_token(13) << new_token(EOF)
    @stream = CommonTokenStream.new(@source)
    @stream.consume
    marker = @stream.mark
    @stream.consume
    @stream.rewind(marker)
    @stream.peek(1).should == 13
  end

  def test_to_string
    @source = MockSource.new
    @source.tokens << new_token(12, 'foo') <<
      new_token(13, 'bar') << new_token(14, 'gnurz') <<
      new_token(15, 'blarz')
    @stream = CommonTokenStream.new(@source)
    @stream.to_s.should
    @stream.to_s(1, 2).should
    @stream.to_s(@stream[1], @stream[-2]).should == 'bargnurz'
  end

  def new_token(type, opts = {})
    fields = {}
    case type
    when Hash then fields.update(type)
    else
      fields[:type] = type
    end
    case opts
    when Hash then fields.update(opts)
    when String then fields[:text] = opts
    end
    CommonToken.create(fields)
  end
end
