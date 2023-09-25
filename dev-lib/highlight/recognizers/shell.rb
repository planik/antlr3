#!/usr/bin/env ruby
#
# Shell.g
#
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jun 18, 2010 05:38:11
# Ruby runtime library version: 1.7.5
# Input grammar file: Shell.g
# Generated at: 2010-07-03 23:18:14
#

# ~~~> start load path setup
this_directory = __dir__
$LOAD_PATH.unshift(this_directory) unless $LOAD_PATH.include?(this_directory)

antlr_load_failed = proc do
  load_path = $LOAD_PATH.map { |dir| '  - ' << dir }.join($/)
  raise LoadError, <<~END.strip!
    #{'  '}
    Failed to load the ANTLR3 runtime library (version 1.7.5):

    Ensure the library has been installed on your system and is available
    on the load path. If rubygems is available on your system, this can
    be done with the command:
    #{'  '}
      gem install antlr3

    Current load path:
    #{load_path}

  END
end

defined?(ANTLR3) or begin
  # 1: try to load the ruby antlr3 runtime library from the system path
  require 'antlr3'
rescue LoadError
  # 2: try to load rubygems if it isn't already loaded
  defined?(Gem) or begin
    require 'rubygems'
  rescue LoadError
    antlr_load_failed.call
  end

  # 3: try to activate the antlr3 gem
  begin
    Gem.activate('antlr3', '~> 1.7.5')
  rescue Gem::LoadError
    antlr_load_failed.call
  end

  require 'antlr3'
end
# <~~~ end load path setup

module Shell
  # TokenData defines all of the token type integer values
  # as constants, which will be included in all
  # ANTLR-generated recognizers.
  const_defined?(:TokenData) or TokenData = ANTLR3::TokenScheme.new

  module TokenData
    # define the token constants
    define_tokens(GLOB: 13, COMMAND_NAME: 4, CHUNK: 15, SWITCH: 5,
                  SHELL_STRING: 7, EOF: -1, SPACE: 10, WS: 8,
                  VARIABLE: 12, PIPELINE_OPERATOR: 18, REDIRECT: 19,
                  CMD_OUTPUT: 9, CLOSE_PAR: 17, COMMAND_END: 11,
                  CHUNK_CHAR: 14, COMMENT: 20, OPEN_PAR: 16, STRING: 6)
  end

  class Lexer < ANTLR3::Lexer
    @grammar_home = Shell
    include TokenData

    begin
      generated_using('Shell.g', '3.2.1-SNAPSHOT Jun 18, 2010 05:38:11', '1.7.5')
    rescue NoMethodError => e
      # ignore
    end

    RULE_NAMES   = %w[STRING SHELL_STRING CMD_OUTPUT SPACE COMMAND_END
                      VARIABLE GLOB CHUNK OPEN_PAR CLOSE_PAR
                      PIPELINE_OPERATOR REDIRECT COMMENT CHUNK_CHAR
                      WS].freeze
    RULE_METHODS = %i[string! shell_string! cmd_output! space! command_end!
                      variable! glob! chunk! open_par! close_par!
                      pipeline_operator! redirect! comment! chunk_char!
                      ws!].freeze

    def initialize(input = nil, options = {})
      super(input, options)
      # - - - - - - begin action @lexer::init - - - - - -
      # Shell.g

      @cmd_start = true

      # - - - - - - end action @lexer::init - - - - - - -
    end

    # - - - - - - - - - - - lexer rules - - - - - - - - - - - -
    # lexer rule string! (STRING)
    # (in Shell.g)
    def string!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )

      type = STRING
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 15:3: ( '\"' (~ ( '\"' | '\\\\' ) | '\\\\' . )* '\"' | '\\'' (~ ( '\\'' | '\\\\' ) | '\\\\' . )* '\\'' )
      alt_3 = 2
      look_3_0 = @input.peek(1)

      if look_3_0 == 0x22
        alt_3 = 1
      elsif look_3_0 == 0x27
        alt_3 = 2
      else
        raise NoViableAlternative('', 3, 0)
      end
      case alt_3
      when 1
        # at line 15:5: '\"' (~ ( '\"' | '\\\\' ) | '\\\\' . )* '\"'
        match(0x22)
        # at line 15:10: (~ ( '\"' | '\\\\' ) | '\\\\' . )*
        while true # decision 1
          alt_1 = 3
          look_1_0 = @input.peek(1)

          if look_1_0.between?(0x0, 0x21) || look_1_0.between?(0x23, 0x5b) || look_1_0.between?(0x5d, 0xffff)
            alt_1 = 1
          elsif look_1_0 == 0x5c
            alt_1 = 2

          end
          case alt_1
          when 1
            # at line 15:12: ~ ( '\"' | '\\\\' )
            if @input.peek(1).between?(0x0,
                                       0x21) || @input.peek(1).between?(0x23,
                                                                        0x5b) || @input.peek(1).between?(0x5d, 0xff)
              @input.consume
            else
              mse = MismatchedSet(nil)
              recover mse
              raise mse
            end

          when 2
            # at line 15:29: '\\\\' .
            match(0x5c)
            match_any

          else
            break # out of loop for decision 1
          end
        end # loop for decision 1
        match(0x22)

      when 2
        # at line 16:5: '\\'' (~ ( '\\'' | '\\\\' ) | '\\\\' . )* '\\''
        match(0x27)
        # at line 16:10: (~ ( '\\'' | '\\\\' ) | '\\\\' . )*
        while true # decision 2
          alt_2 = 3
          look_2_0 = @input.peek(1)

          if look_2_0.between?(0x0, 0x26) || look_2_0.between?(0x28, 0x5b) || look_2_0.between?(0x5d, 0xffff)
            alt_2 = 1
          elsif look_2_0 == 0x5c
            alt_2 = 2

          end
          case alt_2
          when 1
            # at line 16:12: ~ ( '\\'' | '\\\\' )
            if @input.peek(1).between?(0x0,
                                       0x26) || @input.peek(1).between?(0x28,
                                                                        0x5b) || @input.peek(1).between?(0x5d, 0xff)
              @input.consume
            else
              mse = MismatchedSet(nil)
              recover mse
              raise mse
            end

          when 2
            # at line 16:29: '\\\\' .
            match(0x5c)
            match_any

          else
            break # out of loop for decision 2
          end
        end # loop for decision 2
        match(0x27)

      end

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 1 )
    end

    # lexer rule shell_string! (SHELL_STRING)
    # (in Shell.g)
    def shell_string!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )

      type = SHELL_STRING
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 20:5: '`' (~ ( '`' | '\\\\' ) | '\\\\' . )* '`'
      match(0x60)
      # at line 20:9: (~ ( '`' | '\\\\' ) | '\\\\' . )*
      while true # decision 4
        alt_4 = 3
        look_4_0 = @input.peek(1)

        if look_4_0.between?(0x0, 0x5b) || look_4_0.between?(0x5d, 0x5f) || look_4_0.between?(0x61, 0xffff)
          alt_4 = 1
        elsif look_4_0 == 0x5c
          alt_4 = 2

        end
        case alt_4
        when 1
          # at line 20:11: ~ ( '`' | '\\\\' )
          if @input.peek(1).between?(0x0,
                                     0x5b) || @input.peek(1).between?(0x5d, 0x5f) || @input.peek(1).between?(0x61, 0xff)
            @input.consume
          else
            mse = MismatchedSet(nil)
            recover mse
            raise mse
          end

        when 2
          # at line 20:27: '\\\\' .
          match(0x5c)
          match_any

        else
          break # out of loop for decision 4
        end
      end # loop for decision 4
      match(0x60)

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 2 )
    end

    # lexer rule cmd_output! (CMD_OUTPUT)
    # (in Shell.g)
    def cmd_output!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )

      type = CMD_OUTPUT
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 24:5: {...}? => WS (~ '\\n' )+ ( '\\n' WS (~ '\\n' )* )* ( '\\n' )*
      raise FailedPredicate('CMD_OUTPUT', ' @cmd_start ') unless @cmd_start

      ws!
      # at file 24:26: (~ '\\n' )+
      match_count_5 = 0
      while true
        alt_5 = 2
        look_5_0 = @input.peek(1)

        alt_5 = 1 if look_5_0.between?(0x0, 0x9) || look_5_0.between?(0xb, 0xffff)
        case alt_5
        when 1
          # at line 24:26: ~ '\\n'
          if @input.peek(1).between?(0x0, 0x9) || @input.peek(1).between?(0xb, 0xff)
            @input.consume
          else
            mse = MismatchedSet(nil)
            recover mse
            raise mse
          end

        else
          match_count_5 > 0 and break
          eee = EarlyExit(5)

          raise eee
        end
        match_count_5 += 1
      end

      # at line 24:33: ( '\\n' WS (~ '\\n' )* )*
      while true # decision 7
        alt_7 = 2
        look_7_0 = @input.peek(1)

        if look_7_0 == 0xa
          look_7_1 = @input.peek(2)

          alt_7 = 1 if [0x9, 0x20].include?(look_7_1)

        end
        case alt_7
        when 1
          # at line 24:35: '\\n' WS (~ '\\n' )*
          match(0xa)
          ws!
          # at line 24:43: (~ '\\n' )*
          while true # decision 6
            alt_6 = 2
            look_6_0 = @input.peek(1)

            alt_6 = 1 if look_6_0.between?(0x0, 0x9) || look_6_0.between?(0xb, 0xffff)
            case alt_6
            when 1
              # at line 24:43: ~ '\\n'
              if @input.peek(1).between?(0x0, 0x9) || @input.peek(1).between?(0xb, 0xff)
                @input.consume
              else
                mse = MismatchedSet(nil)
                recover mse
                raise mse
              end

            else
              break # out of loop for decision 6
            end
          end # loop for decision 6

        else
          break # out of loop for decision 7
        end
      end # loop for decision 7
      # at line 24:53: ( '\\n' )*
      while true # decision 8
        alt_8 = 2
        look_8_0 = @input.peek(1)

        alt_8 = 1 if look_8_0 == 0xa
        case alt_8
        when 1
          # at line 24:53: '\\n'
          match(0xa)

        else
          break # out of loop for decision 8
        end
      end # loop for decision 8

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 3 )
    end

    # lexer rule space! (SPACE)
    # (in Shell.g)
    def space!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )

      type = SPACE
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 28:5: WS
      ws!

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 4 )
    end

    # lexer rule command_end! (COMMAND_END)
    # (in Shell.g)
    def command_end!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )

      type = COMMAND_END
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 33:3: ( ( '\\r' )? '\\n' | ';' )
      alt_10 = 2
      look_10_0 = @input.peek(1)

      if [0xa, 0xd].include?(look_10_0)
        alt_10 = 1
      elsif look_10_0 == 0x3b
        alt_10 = 2
      else
        raise NoViableAlternative('', 10, 0)
      end
      case alt_10
      when 1
        # at line 33:5: ( '\\r' )? '\\n'
        # at line 33:5: ( '\\r' )?
        alt_9 = 2
        look_9_0 = @input.peek(1)

        alt_9 = 1 if look_9_0 == 0xd
        case alt_9
        when 1
          # at line 33:5: '\\r'
          match(0xd)

        end
        match(0xa)

      when 2
        # at line 34:5: ';'
        match(0x3b)

      end

      @state.type = type
      @state.channel = channel
      # --> action
      @cmd_start = true
      # <-- action

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 5 )
    end

    # lexer rule variable! (VARIABLE)
    # (in Shell.g)
    def variable!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )

      type = VARIABLE
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 38:5: '$' ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '-' | '_' )+
      match(0x24)
      # at file 38:9: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '-' | '_' )+
      match_count_11 = 0
      while true
        alt_11 = 2
        look_11_0 = @input.peek(1)

        if look_11_0 == 0x2d || look_11_0.between?(0x30,
                                                   0x39) || look_11_0.between?(0x41,
                                                                               0x5a) || look_11_0 == 0x5f || look_11_0.between?(
                                                                                 0x61, 0x7a
                                                                               )
          alt_11 = 1

        end
        case alt_11
        when 1
          # at line
          if @input.peek(1) == 0x2d || @input.peek(1).between?(0x30,
                                                               0x39) || @input.peek(1).between?(0x41,
                                                                                                0x5a) || @input.peek(1) == 0x5f || @input.peek(1).between?(
                                                                                                  0x61, 0x7a
                                                                                                )
            @input.consume
          else
            mse = MismatchedSet(nil)
            recover mse
            raise mse
          end

        else
          match_count_11 > 0 and break
          eee = EarlyExit(11)

          raise eee
        end
        match_count_11 += 1
      end

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 6 )
    end

    # lexer rule glob! (GLOB)
    # (in Shell.g)
    def glob!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )

      type = GLOB
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 42:5: ( '?' | '*' )+
      # at file 42:5: ( '?' | '*' )+
      match_count_12 = 0
      while true
        alt_12 = 2
        look_12_0 = @input.peek(1)

        alt_12 = 1 if [0x2a, 0x3f].include?(look_12_0)
        case alt_12
        when 1
          # at line
          if @input.peek(1) == 0x2a || @input.peek(1) == 0x3f
            @input.consume
          else
            mse = MismatchedSet(nil)
            recover mse
            raise mse
          end

        else
          match_count_12 > 0 and break
          eee = EarlyExit(12)

          raise eee
        end
        match_count_12 += 1
      end

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 7 )
    end

    # lexer rule chunk! (CHUNK)
    # (in Shell.g)
    def chunk!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )

      type = CHUNK
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 47:3: ( ( '-' )+ ( CHUNK_CHAR )* | ( CHUNK_CHAR )+ )
      alt_16 = 2
      look_16_0 = @input.peek(1)

      if look_16_0 == 0x2d
        alt_16 = 1
      elsif look_16_0.between?(0x0,
                               0x8) || look_16_0.between?(0xb,
                                                          0xc) || look_16_0.between?(0xe,
                                                                                     0x1f) || look_16_0 == 0x21 || look_16_0.between?(0x25,
                                                                                                                                      0x26) || look_16_0.between?(0x2b,
                                                                                                                                                                  0x2c) || look_16_0.between?(0x2e,
                                                                                                                                                                                              0x3a) || look_16_0 == 0x3d || look_16_0.between?(0x40,
                                                                                                                                                                                                                                               0x5f) || look_16_0.between?(
                                                                                                                                                                                                                                                 0x61, 0x7a
                                                                                                                                                                                                                                               ) || look_16_0.between?(
                                                                                                                                                                                                                                                 0x7f, 0xffff
                                                                                                                                                                                                                                               )
        alt_16 = 2
      else
        raise NoViableAlternative('', 16, 0)
      end
      case alt_16
      when 1
        # at line 47:5: ( '-' )+ ( CHUNK_CHAR )*
        # at file 47:5: ( '-' )+
        match_count_13 = 0
        while true
          alt_13 = 2
          look_13_0 = @input.peek(1)

          alt_13 = 1 if look_13_0 == 0x2d
          case alt_13
          when 1
            # at line 47:5: '-'
            match(0x2d)

          else
            match_count_13 > 0 and break
            eee = EarlyExit(13)

            raise eee
          end
          match_count_13 += 1
        end

        # at line 47:10: ( CHUNK_CHAR )*
        while true # decision 14
          alt_14 = 2
          look_14_0 = @input.peek(1)

          if look_14_0.between?(0x0,
                                0x8) || look_14_0.between?(0xb,
                                                           0xc) || look_14_0.between?(0xe,
                                                                                      0x1f) || look_14_0 == 0x21 || look_14_0.between?(0x25,
                                                                                                                                       0x26) || look_14_0.between?(0x2b,
                                                                                                                                                                   0x3a) || look_14_0 == 0x3d || look_14_0.between?(0x40,
                                                                                                                                                                                                                    0x5f) || look_14_0.between?(
                                                                                                                                                                                                                      0x61, 0x7a
                                                                                                                                                                                                                    ) || look_14_0.between?(
                                                                                                                                                                                                                      0x7f, 0xffff
                                                                                                                                                                                                                    )
            alt_14 = 1

          end
          case alt_14
          when 1
            # at line 47:10: CHUNK_CHAR
            chunk_char!

          else
            break # out of loop for decision 14
          end
        end # loop for decision 14
        # --> action
        type = SWITCH
        # <-- action

      when 2
        # at line 48:5: ( CHUNK_CHAR )+
        # at file 48:5: ( CHUNK_CHAR )+
        match_count_15 = 0
        while true
          alt_15 = 2
          look_15_0 = @input.peek(1)

          if look_15_0.between?(0x0,
                                0x8) || look_15_0.between?(0xb,
                                                           0xc) || look_15_0.between?(0xe,
                                                                                      0x1f) || look_15_0 == 0x21 || look_15_0.between?(0x25,
                                                                                                                                       0x26) || look_15_0.between?(0x2b,
                                                                                                                                                                   0x3a) || look_15_0 == 0x3d || look_15_0.between?(0x40,
                                                                                                                                                                                                                    0x5f) || look_15_0.between?(
                                                                                                                                                                                                                      0x61, 0x7a
                                                                                                                                                                                                                    ) || look_15_0.between?(
                                                                                                                                                                                                                      0x7f, 0xffff
                                                                                                                                                                                                                    )
            alt_15 = 1

          end
          case alt_15
          when 1
            # at line 48:5: CHUNK_CHAR
            chunk_char!

          else
            match_count_15 > 0 and break
            eee = EarlyExit(15)

            raise eee
          end
          match_count_15 += 1
        end

        # --> action
        @cmd_start and type = COMMAND_NAME
        # <-- action

      end

      @state.type = type
      @state.channel = channel
      # --> action
      @cmd_start = false
      # <-- action

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 8 )
    end

    # lexer rule open_par! (OPEN_PAR)
    # (in Shell.g)
    def open_par!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )

      type = OPEN_PAR
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 51:14: '('
      match(0x28)

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 9 )
    end

    # lexer rule close_par! (CLOSE_PAR)
    # (in Shell.g)
    def close_par!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )

      type = CLOSE_PAR
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 52:14: ')'
      match(0x29)

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 10 )
    end

    # lexer rule pipeline_operator! (PIPELINE_OPERATOR)
    # (in Shell.g)
    def pipeline_operator!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )

      type = PIPELINE_OPERATOR
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 55:3: ( '&&' | '||' | '|' | '&' )
      alt_17 = 4
      look_17_0 = @input.peek(1)

      if look_17_0 == 0x26
        look_17_1 = @input.peek(2)

        alt_17 = if look_17_1 == 0x26
                   1
                 else
                   4
                 end
      elsif look_17_0 == 0x7c
        look_17_2 = @input.peek(2)

        alt_17 = if look_17_2 == 0x7c
                   2
                 else
                   3
                 end
      else
        raise NoViableAlternative('', 17, 0)
      end
      case alt_17
      when 1
        # at line 55:5: '&&'
        match('&&')

      when 2
        # at line 55:12: '||'
        match('||')

      when 3
        # at line 55:19: '|'
        match(0x7c)

      when 4
        # at line 55:25: '&'
        match(0x26)
        # --> action
        @cmd_start = true
        # <-- action

      end

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 11 )
    end

    # lexer rule redirect! (REDIRECT)
    # (in Shell.g)
    def redirect!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )

      type = REDIRECT
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 59:5: ( '0' .. '9' )* ( '>>' | '>' | '<<' | '<' ) ( '&' ( '0' .. '9' )+ )?
      # at line 59:5: ( '0' .. '9' )*
      while true # decision 18
        alt_18 = 2
        look_18_0 = @input.peek(1)

        alt_18 = 1 if look_18_0.between?(0x30, 0x39)
        case alt_18
        when 1
          # at line 59:6: '0' .. '9'
          match_range(0x30, 0x39)

        else
          break # out of loop for decision 18
        end
      end # loop for decision 18
      # at line 59:17: ( '>>' | '>' | '<<' | '<' )
      alt_19 = 4
      look_19_0 = @input.peek(1)

      if look_19_0 == 0x3e
        look_19_1 = @input.peek(2)

        alt_19 = if look_19_1 == 0x3e
                   1
                 else
                   2
                 end
      elsif look_19_0 == 0x3c
        look_19_2 = @input.peek(2)

        alt_19 = if look_19_2 == 0x3c
                   3
                 else
                   4
                 end
      else
        raise NoViableAlternative('', 19, 0)
      end
      case alt_19
      when 1
        # at line 59:18: '>>'
        match('>>')

      when 2
        # at line 59:25: '>'
        match(0x3e)

      when 3
        # at line 59:31: '<<'
        match('<<')

      when 4
        # at line 59:38: '<'
        match(0x3c)

      end
      # at line 59:43: ( '&' ( '0' .. '9' )+ )?
      alt_21 = 2
      look_21_0 = @input.peek(1)

      alt_21 = 1 if look_21_0 == 0x26
      case alt_21
      when 1
        # at line 59:44: '&' ( '0' .. '9' )+
        match(0x26)
        # at file 59:48: ( '0' .. '9' )+
        match_count_20 = 0
        while true
          alt_20 = 2
          look_20_0 = @input.peek(1)

          alt_20 = 1 if look_20_0.between?(0x30, 0x39)
          case alt_20
          when 1
            # at line 59:49: '0' .. '9'
            match_range(0x30, 0x39)

          else
            match_count_20 > 0 and break
            eee = EarlyExit(20)

            raise eee
          end
          match_count_20 += 1
        end

      end

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 12 )
    end

    # lexer rule comment! (COMMENT)
    # (in Shell.g)
    def comment!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )

      type = COMMENT
      channel = ANTLR3::DEFAULT_CHANNEL

      # - - - - main rule block - - - -
      # at line 63:5: '#' (~ ( '\\r' | '\\n' ) )*
      match(0x23)
      # at line 63:9: (~ ( '\\r' | '\\n' ) )*
      while true # decision 22
        alt_22 = 2
        look_22_0 = @input.peek(1)

        alt_22 = 1 if look_22_0.between?(0x0, 0x9) || look_22_0.between?(0xb, 0xc) || look_22_0.between?(0xe, 0xffff)
        case alt_22
        when 1
          # at line 63:11: ~ ( '\\r' | '\\n' )
          if @input.peek(1).between?(0x0,
                                     0x9) || @input.peek(1).between?(0xb, 0xc) || @input.peek(1).between?(0xe, 0xff)
            @input.consume
          else
            mse = MismatchedSet(nil)
            recover mse
            raise mse
          end

        else
          break # out of loop for decision 22
        end
      end # loop for decision 22

      @state.type = type
      @state.channel = channel

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 13 )
    end

    # lexer rule chunk_char! (CHUNK_CHAR)
    # (in Shell.g)
    def chunk_char!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )

      # - - - - main rule block - - - -
      # at line 68:3: (~ ( '>' | '<' | '#' | '`' | '\"' | '\\'' | '|' | '(' | ')' | '$' | ';' | ' ' | '?' | '*' | '~' | '\\\\' | '\\t' | '{' | '}' | '\\n' | '\\r' ) | '\\\\' . )
      alt_23 = 2
      look_23_0 = @input.peek(1)

      if look_23_0.between?(0x0,
                            0x8) || look_23_0.between?(0xb,
                                                       0xc) || look_23_0.between?(0xe,
                                                                                  0x1f) || look_23_0 == 0x21 || look_23_0.between?(0x25,
                                                                                                                                   0x26) || look_23_0.between?(0x2b,
                                                                                                                                                               0x3a) || look_23_0 == 0x3d || look_23_0.between?(0x40,
                                                                                                                                                                                                                0x5b) || look_23_0.between?(
                                                                                                                                                                                                                  0x5d, 0x5f
                                                                                                                                                                                                                ) || look_23_0.between?(
                                                                                                                                                                                                                  0x61, 0x7a
                                                                                                                                                                                                                ) || look_23_0.between?(
                                                                                                                                                                                                                  0x7f, 0xffff
                                                                                                                                                                                                                )
        alt_23 = 1
      elsif look_23_0 == 0x5c
        alt_23 = 2
      else
        raise NoViableAlternative('', 23, 0)
      end
      case alt_23
      when 1
        # at line 68:5: ~ ( '>' | '<' | '#' | '`' | '\"' | '\\'' | '|' | '(' | ')' | '$' | ';' | ' ' | '?' | '*' | '~' | '\\\\' | '\\t' | '{' | '}' | '\\n' | '\\r' )
        if @input.peek(1).between?(0x0,
                                   0x8) || @input.peek(1).between?(0xb,
                                                                   0xc) || @input.peek(1).between?(0xe,
                                                                                                   0x1f) || @input.peek(1) == 0x21 || @input.peek(1).between?(0x25,
                                                                                                                                                              0x26) || @input.peek(1).between?(0x2b,
                                                                                                                                                                                               0x3a) || @input.peek(1) == 0x3d || @input.peek(1).between?(0x40,
                                                                                                                                                                                                                                                          0x5b) || @input.peek(1).between?(0x5d,
                                                                                                                                                                                                                                                                                           0x5f) || @input.peek(1).between?(
                                                                                                                                                                                                                                                                                             0x61, 0x7a
                                                                                                                                                                                                                                                                                           ) || @input.peek(1).between?(
                                                                                                                                                                                                                                                                                             0x7f, 0xff
                                                                                                                                                                                                                                                                                           )
          @input.consume
        else
          mse = MismatchedSet(nil)
          recover mse
          raise mse
        end

      when 2
        # at line 70:5: '\\\\' .
        match(0x5c)
        match_any

      end

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 14 )
    end

    # lexer rule ws! (WS)
    # (in Shell.g)
    def ws!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )

      # - - - - main rule block - - - -
      # at line 74:5: ( ' ' | '\\t' )+
      # at file 74:5: ( ' ' | '\\t' )+
      match_count_24 = 0
      while true
        alt_24 = 2
        look_24_0 = @input.peek(1)

        alt_24 = 1 if [0x9, 0x20].include?(look_24_0)
        case alt_24
        when 1
          # at line
          if @input.peek(1) == 0x9 || @input.peek(1) == 0x20
            @input.consume
          else
            mse = MismatchedSet(nil)
            recover mse
            raise mse
          end

        else
          match_count_24 > 0 and break
          eee = EarlyExit(24)

          raise eee
        end
        match_count_24 += 1
      end

      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 15 )
    end

    # main rule used to study the input at the current position,
    # and choose the proper lexer rule to call in order to
    # fetch the next token
    #
    # usually, you don't make direct calls to this method,
    # but instead use the next_token method, which will
    # build and emit the actual next token
    def token!
      # at line 1:8: ( STRING | SHELL_STRING | CMD_OUTPUT | SPACE | COMMAND_END | VARIABLE | GLOB | CHUNK | OPEN_PAR | CLOSE_PAR | PIPELINE_OPERATOR | REDIRECT | COMMENT )
      alt_25 = 13
      alt_25 = @dfa25.predict(@input)
      case alt_25
      when 1
        # at line 1:10: STRING
        string!

      when 2
        # at line 1:17: SHELL_STRING
        shell_string!

      when 3
        # at line 1:30: CMD_OUTPUT
        cmd_output!

      when 4
        # at line 1:41: SPACE
        space!

      when 5
        # at line 1:47: COMMAND_END
        command_end!

      when 6
        # at line 1:59: VARIABLE
        variable!

      when 7
        # at line 1:68: GLOB
        glob!

      when 8
        # at line 1:73: CHUNK
        chunk!

      when 9
        # at line 1:79: OPEN_PAR
        open_par!

      when 10
        # at line 1:88: CLOSE_PAR
        close_par!

      when 11
        # at line 1:98: PIPELINE_OPERATOR
        pipeline_operator!

      when 12
        # at line 1:116: REDIRECT
        redirect!

      when 13
        # at line 1:125: COMMENT
        comment!

      end
    end

    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA25 < ANTLR3::DFA
      EOT = unpack(3, -1, 1, 15, 4, -1, 1, 7, 2, -1, 1, 7, 4, -1, 1, 19,
                   3, -1)
      EOF = unpack(20, -1)
      MIN = unpack(1, 0, 2, -1, 1, 0, 4, -1, 1, 38, 2, -1, 1, 48, 4, -1,
                   1, 0, 2, -1, 1, 0)
      MAX = unpack(1, -1, 2, -1, 1, -1, 4, -1, 1, 38, 2, -1, 1, 62, 4,
                   -1, 1, -1, 2, -1, 1, 0)
      ACCEPT = unpack(1, -1, 1, 1, 1, 2, 1, -1, 1, 5, 1, 6, 1, 7, 1, 8,
                      1, -1, 1, 9, 1, 10, 1, -1, 1, 11, 1, 12, 1, 13, 1,
                      4, 1, -1, 1, 3, 1, 8, 1, -1)
      SPECIAL = unpack(1, 0, 2, -1, 1, 1, 12, -1, 1, 3, 2, -1, 1, 2)
      TRANSITION = [
        unpack(9, 7, 1, 3, 1, 4, 2, 7, 1, 4, 18, 7, 1, 3, 1, 7, 1, 1, 1,
               14, 1, 5, 1, 7, 1, 8, 1, 1, 1, 9, 1, 10, 1, 6, 5, 7, 10,
               11, 1, 7, 1, 4, 1, 13, 1, 7, 1, 13, 1, 6, 32, 7, 1, 2, 26,
               7, 1, -1, 1, 12, 2, -1, 65_409, 7),
        unpack,
        unpack,
        unpack(9, 17, 1, 16, 1, -1, 21, 17, 1, 16, 65_503, 17),
        unpack,
        unpack,
        unpack,
        unpack,
        unpack(1, 18),
        unpack,
        unpack,
        unpack(10, 11, 2, -1, 1, 13, 1, -1, 1, 13),
        unpack,
        unpack,
        unpack,
        unpack,
        unpack(9, 17, 1, 16, 22, 17, 1, 16, 65_503, 17),
        unpack,
        unpack,
        unpack(1, -1)
      ].freeze

      (0...MIN.length).zip(MIN, MAX) do |i, a, z|
        MAX[i] %= 0x10000 if a > 0 and z < 0
      end

      @decision = 25

      def description
        <<-'__DFA_DESCRIPTION__'.strip!
          1:1: Tokens : ( STRING | SHELL_STRING | CMD_OUTPUT | SPACE | COMMAND_END | VARIABLE | GLOB | CHUNK | OPEN_PAR | CLOSE_PAR | PIPELINE_OPERATOR | REDIRECT | COMMENT );
        __DFA_DESCRIPTION__
      end
    end

    private

    def initialize_dfas
      begin
        super
      rescue StandardError
        nil
      end
      @dfa25 = DFA25.new(self, 25) do |s|
        case s
        when 0
          look_25_0 = @input.peek
          s = -1
          if [0x22, 0x27].include?(look_25_0)
            s = 1
          elsif look_25_0 == 0x60
            s = 2
          elsif [0x9, 0x20].include?(look_25_0)
            s = 3
          elsif [0xa, 0xd, 0x3b].include?(look_25_0)
            s = 4
          elsif look_25_0 == 0x24
            s = 5
          elsif [0x2a, 0x3f].include?(look_25_0)
            s = 6
          elsif look_25_0.between?(0x0,
                                   0x8) || look_25_0.between?(0xb,
                                                              0xc) || look_25_0.between?(0xe,
                                                                                         0x1f) || look_25_0 == 0x21 || look_25_0 == 0x25 || look_25_0.between?(0x2b,
                                                                                                                                                               0x2f) || look_25_0 == 0x3a || look_25_0 == 0x3d || look_25_0.between?(0x40,
                                                                                                                                                                                                                                     0x5f) || look_25_0.between?(
                                                                                                                                                                                                                                       0x61, 0x7a
                                                                                                                                                                                                                                     ) || look_25_0.between?(
                                                                                                                                                                                                                                       0x7f, 0xffff
                                                                                                                                                                                                                                     )
            s = 7
          elsif look_25_0 == 0x26
            s = 8
          elsif look_25_0 == 0x28
            s = 9
          elsif look_25_0 == 0x29
            s = 10
          elsif look_25_0.between?(0x30, 0x39)
            s = 11
          elsif look_25_0 == 0x7c
            s = 12
          elsif [0x3c, 0x3e].include?(look_25_0)
            s = 13
          elsif look_25_0 == 0x23
            s = 14
          end

        when 1
          look_25_3 = @input.peek
          index_25_3 = @input.index
          @input.rewind(@input.last_marker, false)
          s = -1
          s = if [0x9, 0x20].include?(look_25_3)
                16
              elsif (look_25_3.between?(0x0,
                                        0x8) || look_25_3.between?(0xb,
                                                                   0x1f) || look_25_3.between?(0x21,
                                                                                               0xffff)) and @cmd_start
                17
              else
                15
              end

          @input.seek(index_25_3)

        when 2
          look_25_19 = @input.peek
          index_25_19 = @input.index
          @input.rewind(@input.last_marker, false)
          s = -1
          if @cmd_start
            s = 17
          elsif true
            s = 15
          end

          @input.seek(index_25_19)

        when 3
          look_25_16 = @input.peek
          index_25_16 = @input.index
          @input.rewind(@input.last_marker, false)
          s = -1
          s = if (look_25_16.between?(0x0,
                                      0x8) || look_25_16.between?(0xa,
                                                                  0x1f) || look_25_16.between?(0x21,
                                                                                               0xffff)) and @cmd_start
                17
              elsif [0x9, 0x20].include?(look_25_16)
                16
              else
                19
              end

          @input.seek(index_25_16)

        end

        if s < 0
          nva = ANTLR3::Error::NoViableAlternative.new(@dfa25.description, 25, s, input)
          @dfa25.error(nva)
          raise nva
        end

        s
      end
    end
  end # class Lexer < ANTLR3::Lexer

  at_exit { Lexer.main(ARGV) } if __FILE__ == $0
end
