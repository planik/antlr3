#!/usr/bin/env ruby
#
# SearchExpression.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.1
# Input grammar file: SearchExpression.g
# Generated at: 2011-01-10 00:41:00
#

# ~~~> start load path setup
this_directory = __dir__
$LOAD_PATH.unshift(this_directory) unless $LOAD_PATH.include?(this_directory)

antlr_load_failed = proc do
  load_path = $LOAD_PATH.map { |dir| '  - ' << dir }.join($/)
  raise LoadError, <<~END.strip!
    #{'  '}
    Failed to load the ANTLR3 runtime library (version 1.8.1):

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
    Gem.activate('antlr3', '~> 1.8.1')
  rescue Gem::LoadError
    antlr_load_failed.call
  end

  require 'antlr3'
end
# <~~~ end load path setup

module SearchExpression
  # TokenData defines all of the token type integer values
  # as constants, which will be included in all
  # ANTLR-generated recognizers.
  const_defined?(:TokenData) or TokenData = ANTLR3::TokenScheme.new

  module TokenData
    # define the token constants
    define_tokens(CHUNK: 5, MATCH: 4, REGEX: 7, EOF: -1, T__9: 9,
                  T__19: 19, T__16: 16, WS: 8, T__15: 15, T__18: 18,
                  T__17: 17, T__12: 12, T__11: 11, T__14: 14,
                  T__13: 13, T__10: 10, STRING: 6)

    # register the proper human-readable name or literal value
    # for each token type
    #
    # this is necessary because anonymous tokens, which are
    # created from literal values in the grammar, do not
    # have descriptive names
    register_names('MATCH', 'CHUNK', 'STRING', 'REGEX', 'WS', "'and'",
                   "'or'", "'xor'", "'not'", "':'", "'('", "')'", "'['",
                   "']'", "'{'", "'}'")
  end

  class Parser < ANTLR3::Parser
    @grammar_home = SearchExpression
    include ANTLR3::ASTBuilder

    RULE_METHODS = %i[search_expression not_expression atom group
                      term].freeze

    include TokenData

    begin
      generated_using('SearchExpression.g', '3.2.1-SNAPSHOT Jul 31, 2010 19:34:52', '1.8.1')
    rescue NoMethodError => e
      # ignore
    end

    def initialize(input, options = {})
      super(input, options)
    end
    # - - - - - - - - - - - - Rules - - - - - - - - - - - - -
    SearchExpressionReturnValue = define_return_scope

    #
    # parser rule search_expression
    #
    # (in SearchExpression.g)
    # 13:1: search_expression : not_expression ( ( 'and' | 'or' | 'xor' ) not_expression )* ;
    #
    def search_expression
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )
      return_value = SearchExpressionReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      root_0 = nil
      string_literal2 = nil
      string_literal3 = nil
      string_literal4 = nil
      not_expression1 = nil
      not_expression5 = nil

      tree_for_string_literal2 = nil
      tree_for_string_literal3 = nil
      tree_for_string_literal4 = nil

      begin
        root_0 = @adaptor.create_flat_list

        # at line 14:7: not_expression ( ( 'and' | 'or' | 'xor' ) not_expression )*
        @state.following.push(TOKENS_FOLLOWING_not_expression_IN_search_expression_48)
        not_expression1 = not_expression
        @state.following.pop
        @adaptor.add_child(root_0, not_expression1.tree)
        # at line 14:22: ( ( 'and' | 'or' | 'xor' ) not_expression )*
        while true # decision 2
          alt_2 = 2
          look_2_0 = @input.peek(1)

          alt_2 = 1 if look_2_0.between?(T__9, T__11)
          case alt_2
          when 1
            # at line 14:24: ( 'and' | 'or' | 'xor' ) not_expression
            # at line 14:24: ( 'and' | 'or' | 'xor' )
            alt_1 = 3
            case look_1 = @input.peek(1)
            when T__9 then alt_1 = 1
            when T__10 then alt_1 = 2
            when T__11 then alt_1 = 3
            else
              raise NoViableAlternative('', 1, 0)
            end
            case alt_1
            when 1
              # at line 14:25: 'and'
              string_literal2 = match(T__9, TOKENS_FOLLOWING_T__9_IN_search_expression_53)

              tree_for_string_literal2 = @adaptor.create_with_payload(string_literal2)
              root_0 = @adaptor.become_root(tree_for_string_literal2, root_0)

            when 2
              # at line 14:34: 'or'
              string_literal3 = match(T__10, TOKENS_FOLLOWING_T__10_IN_search_expression_58)

              tree_for_string_literal3 = @adaptor.create_with_payload(string_literal3)
              root_0 = @adaptor.become_root(tree_for_string_literal3, root_0)

            when 3
              # at line 14:42: 'xor'
              string_literal4 = match(T__11, TOKENS_FOLLOWING_T__11_IN_search_expression_63)

              tree_for_string_literal4 = @adaptor.create_with_payload(string_literal4)
              root_0 = @adaptor.become_root(tree_for_string_literal4, root_0)

            end
            @state.following.push(TOKENS_FOLLOWING_not_expression_IN_search_expression_67)
            not_expression5 = not_expression
            @state.following.pop
            @adaptor.add_child(root_0, not_expression5.tree)

          else
            break # out of loop for decision 2
          end
        end # loop for decision 2
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look(-1)

        return_value.tree = @adaptor.rule_post_processing(root_0)
        @adaptor.set_token_boundaries(return_value.tree, return_value.start, return_value.stop)
      rescue ANTLR3::Error::RecognitionError => e
        report_error(e)
        recover(e)
        return_value.tree = @adaptor.create_error_node(@input, return_value.start, @input.look(-1), e)

        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 1 )
      end

      return_value
    end

    NotExpressionReturnValue = define_return_scope

    #
    # parser rule not_expression
    #
    # (in SearchExpression.g)
    # 17:1: not_expression : ( 'not' )? atom ;
    #
    def not_expression
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )
      return_value = NotExpressionReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      root_0 = nil
      string_literal6 = nil
      atom7 = nil

      tree_for_string_literal6 = nil

      begin
        root_0 = @adaptor.create_flat_list

        # at line 18:7: ( 'not' )? atom
        # at line 18:7: ( 'not' )?
        alt_3 = 2
        look_3_0 = @input.peek(1)

        alt_3 = 1 if look_3_0 == T__12
        case alt_3
        when 1
          # at line 18:9: 'not'
          string_literal6 = match(T__12, TOKENS_FOLLOWING_T__12_IN_not_expression_89)

          tree_for_string_literal6 = @adaptor.create_with_payload(string_literal6)
          root_0 = @adaptor.become_root(tree_for_string_literal6, root_0)

        end
        @state.following.push(TOKENS_FOLLOWING_atom_IN_not_expression_95)
        atom7 = atom
        @state.following.pop
        @adaptor.add_child(root_0, atom7.tree)
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look(-1)

        return_value.tree = @adaptor.rule_post_processing(root_0)
        @adaptor.set_token_boundaries(return_value.tree, return_value.start, return_value.stop)
      rescue ANTLR3::Error::RecognitionError => e
        report_error(e)
        recover(e)
        return_value.tree = @adaptor.create_error_node(@input, return_value.start, @input.look(-1), e)

        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 2 )
      end

      return_value
    end

    AtomReturnValue = define_return_scope

    #
    # parser rule atom
    #
    # (in SearchExpression.g)
    # 21:1: atom : ( group | ( CHUNK ':' )? ( term )+ );
    #
    def atom
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )
      return_value = AtomReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      root_0 = nil
      __CHUNK9__ = nil
      char_literal10 = nil
      group8 = nil
      term11 = nil

      tree_for_CHUNK9 = nil
      tree_for_char_literal10 = nil

      begin
        # at line 22:5: ( group | ( CHUNK ':' )? ( term )+ )
        alt_6 = 2
        look_6_0 = @input.peek(1)

        if [T__14, T__16, T__18].include?(look_6_0)
          alt_6 = 1
        elsif look_6_0.between?(CHUNK, REGEX)
          alt_6 = 2
        else
          raise NoViableAlternative('', 6, 0)
        end
        case alt_6
        when 1
          root_0 = @adaptor.create_flat_list

          # at line 22:7: group
          @state.following.push(TOKENS_FOLLOWING_group_IN_atom_112)
          group8 = group
          @state.following.pop
          @adaptor.add_child(root_0, group8.tree)

        when 2
          root_0 = @adaptor.create_flat_list

          # at line 23:7: ( CHUNK ':' )? ( term )+
          # at line 23:7: ( CHUNK ':' )?
          alt_4 = 2
          look_4_0 = @input.peek(1)

          if look_4_0 == CHUNK
            look_4_1 = @input.peek(2)

            alt_4 = 1 if look_4_1 == T__13
          end
          case alt_4
          when 1
            # at line 23:9: CHUNK ':'
            __CHUNK9__ = match(CHUNK, TOKENS_FOLLOWING_CHUNK_IN_atom_122)

            tree_for_CHUNK9 = @adaptor.create_with_payload(__CHUNK9__)
            @adaptor.add_child(root_0, tree_for_CHUNK9)

            char_literal10 = match(T__13, TOKENS_FOLLOWING_T__13_IN_atom_124)

            tree_for_char_literal10 = @adaptor.create_with_payload(char_literal10)
            root_0 = @adaptor.become_root(tree_for_char_literal10, root_0)

          end
          # at file 23:23: ( term )+
          match_count_5 = 0
          while true
            alt_5 = 2
            look_5_0 = @input.peek(1)

            alt_5 = 1 if look_5_0.between?(CHUNK, REGEX)
            case alt_5
            when 1
              # at line 23:23: term
              @state.following.push(TOKENS_FOLLOWING_term_IN_atom_130)
              term11 = term
              @state.following.pop
              @adaptor.add_child(root_0, term11.tree)

            else
              match_count_5 > 0 and break
              eee = EarlyExit(5)

              raise eee
            end
            match_count_5 += 1
          end

        end # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look(-1)

        return_value.tree = @adaptor.rule_post_processing(root_0)
        @adaptor.set_token_boundaries(return_value.tree, return_value.start, return_value.stop)
      rescue ANTLR3::Error::RecognitionError => e
        report_error(e)
        recover(e)
        return_value.tree = @adaptor.create_error_node(@input, return_value.start, @input.look(-1), e)

        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 3 )
      end

      return_value
    end

    GroupReturnValue = define_return_scope

    #
    # parser rule group
    #
    # (in SearchExpression.g)
    # 26:1: group : ( '(' search_expression ')' | '[' search_expression ']' | '{' search_expression '}' );
    #
    def group
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )
      return_value = GroupReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      root_0 = nil
      char_literal12 = nil
      char_literal14 = nil
      char_literal15 = nil
      char_literal17 = nil
      char_literal18 = nil
      char_literal20 = nil
      search_expression13 = nil
      search_expression16 = nil
      search_expression19 = nil

      tree_for_char_literal12 = nil
      tree_for_char_literal14 = nil
      tree_for_char_literal15 = nil
      tree_for_char_literal17 = nil
      tree_for_char_literal18 = nil
      tree_for_char_literal20 = nil

      begin
        # at line 27:5: ( '(' search_expression ')' | '[' search_expression ']' | '{' search_expression '}' )
        alt_7 = 3
        case look_7 = @input.peek(1)
        when T__14 then alt_7 = 1
        when T__16 then alt_7 = 2
        when T__18 then alt_7 = 3
        else
          raise NoViableAlternative('', 7, 0)
        end
        case alt_7
        when 1
          root_0 = @adaptor.create_flat_list

          # at line 27:7: '(' search_expression ')'
          char_literal12 = match(T__14, TOKENS_FOLLOWING_T__14_IN_group_148)
          @state.following.push(TOKENS_FOLLOWING_search_expression_IN_group_151)
          search_expression13 = search_expression
          @state.following.pop
          @adaptor.add_child(root_0, search_expression13.tree)
          char_literal14 = match(T__15, TOKENS_FOLLOWING_T__15_IN_group_153)

        when 2
          root_0 = @adaptor.create_flat_list

          # at line 28:7: '[' search_expression ']'
          char_literal15 = match(T__16, TOKENS_FOLLOWING_T__16_IN_group_162)
          @state.following.push(TOKENS_FOLLOWING_search_expression_IN_group_165)
          search_expression16 = search_expression
          @state.following.pop
          @adaptor.add_child(root_0, search_expression16.tree)
          char_literal17 = match(T__17, TOKENS_FOLLOWING_T__17_IN_group_167)

        when 3
          root_0 = @adaptor.create_flat_list

          # at line 29:7: '{' search_expression '}'
          char_literal18 = match(T__18, TOKENS_FOLLOWING_T__18_IN_group_176)
          @state.following.push(TOKENS_FOLLOWING_search_expression_IN_group_179)
          search_expression19 = search_expression
          @state.following.pop
          @adaptor.add_child(root_0, search_expression19.tree)
          char_literal20 = match(T__19, TOKENS_FOLLOWING_T__19_IN_group_181)

        end # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look(-1)

        return_value.tree = @adaptor.rule_post_processing(root_0)
        @adaptor.set_token_boundaries(return_value.tree, return_value.start, return_value.stop)
      rescue ANTLR3::Error::RecognitionError => e
        report_error(e)
        recover(e)
        return_value.tree = @adaptor.create_error_node(@input, return_value.start, @input.look(-1), e)

        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 4 )
      end

      return_value
    end

    TermReturnValue = define_return_scope

    #
    # parser rule term
    #
    # (in SearchExpression.g)
    # 32:1: term : ( CHUNK | STRING | REGEX );
    #
    def term
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )
      return_value = TermReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      root_0 = nil
      set21 = nil

      tree_for_set21 = nil

      begin
        root_0 = @adaptor.create_flat_list

        # at line
        set21 = @input.look
        if @input.peek(1).between?(CHUNK, REGEX)
          @input.consume
          @adaptor.add_child(root_0, @adaptor.create_with_payload(set21))
          @state.error_recovery = false
        else
          mse = MismatchedSet(nil)
          raise mse
        end

        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look(-1)

        return_value.tree = @adaptor.rule_post_processing(root_0)
        @adaptor.set_token_boundaries(return_value.tree, return_value.start, return_value.stop)
      rescue ANTLR3::Error::RecognitionError => e
        report_error(e)
        recover(e)
        return_value.tree = @adaptor.create_error_node(@input, return_value.start, @input.look(-1), e)

        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 5 )
      end

      return_value
    end

    TOKENS_FOLLOWING_not_expression_IN_search_expression_48 = Set[1, 9, 10, 11]
    TOKENS_FOLLOWING_T__9_IN_search_expression_53 = Set[5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_T__10_IN_search_expression_58 = Set[5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_T__11_IN_search_expression_63 = Set[5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_not_expression_IN_search_expression_67 = Set[1, 9, 10, 11]
    TOKENS_FOLLOWING_T__12_IN_not_expression_89 = Set[5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_atom_IN_not_expression_95 = Set[1]
    TOKENS_FOLLOWING_group_IN_atom_112 = Set[1]
    TOKENS_FOLLOWING_CHUNK_IN_atom_122 = Set[13]
    TOKENS_FOLLOWING_T__13_IN_atom_124 = Set[5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_term_IN_atom_130 = Set[1, 5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_T__14_IN_group_148 = Set[5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_search_expression_IN_group_151 = Set[15]
    TOKENS_FOLLOWING_T__15_IN_group_153 = Set[1]
    TOKENS_FOLLOWING_T__16_IN_group_162 = Set[5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_search_expression_IN_group_165 = Set[17]
    TOKENS_FOLLOWING_T__17_IN_group_167 = Set[1]
    TOKENS_FOLLOWING_T__18_IN_group_176 = Set[5, 6, 7, 12, 14, 16, 18]
    TOKENS_FOLLOWING_search_expression_IN_group_179 = Set[19]
    TOKENS_FOLLOWING_T__19_IN_group_181 = Set[1]
    TOKENS_FOLLOWING_set_IN_term_0 = Set[1]
  end # class Parser < ANTLR3::Parser

  at_exit { Parser.main(ARGV) } if __FILE__ == $0
end
