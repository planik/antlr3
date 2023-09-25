#!/usr/bin/ruby
require 'antlr3/test/functional'

class TestProfileMode < ANTLR3::Test::Functional
  compile_options profile: true

  inline_grammar(<<-'END')
    grammar SimpleC;

    options { language = Ruby; }

    program
        :   declaration+
        ;

    /** In this rule, the functionHeader left prefix on the last two
     *  alternatives is not LL(k) for a fixed k.  However, it is
     *  LL(*).  The LL(*) algorithm simply scans ahead until it sees
     *  either the ';' or the '{' of the block and then it picks
     *  the appropriate alternative.  Lookhead can be arbitrarily
     *  long in theory, but is <=10 in most cases.  Works great.
     *  Use ANTLRWorks to see the lookahead use (step by Location)
     *  and look for blue tokens in the input window pane. :)
     */
    declaration
        :   variable
        |   functionHeader ';'
        |   functionHeader block
        ;

    variable
        :   type declarator ';'
        ;

    declarator
        :   ID 
        ;

    functionHeader
        :   type ID '(' ( formalParameter ( ',' formalParameter )* )? ')'
        ;

    formalParameter
        :   type declarator        
        ;

    type
        :   'int'   
        |   'char'  
        |   'void'
        |   ID        
        ;

    block
        :   '{'
                variable*
                stat*
            '}'
        ;

    stat: forStat
        | expr ';'      
        | block
        | assignStat ';'
        | ';'
        ;

    forStat
        :   'for' '(' assignStat ';' expr ';' assignStat ')' block        
        ;

    assignStat
        :   ID '=' expr        
        ;

    expr:   condExpr
        ;

    condExpr
        :   aexpr ( ('==' | '<') aexpr )?
        ;

    aexpr
        :   atom ( '+' atom )*
        ;

    atom
        : ID      
        | INT      
        | '(' expr ')'
        ; 

    ID  :   ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
        ;

    INT :	('0'..'9')+
        ;

    WS  :   (   ' '
            |   '\t'
            |   '\r'
            |   '\n'
            )+
            { $channel=HIDDEN; }
        ;
  END

  example 'profile mode output' do
    input = <<-END.fixed_indent(0)
      char c;
      int x;

      void bar(int x);

      int foo(int y, char d) {
        int i;
        for (i=0; i<3; i=i+1) {
          x=3;
          y=5;
        }
      }
    END

    lexer = SimpleC::Lexer.new(input)
    tokens = ANTLR3::CommonTokenStream.new(lexer)
    parser = SimpleC::Parser.new(tokens)
    parser.program

    profile_data = parser.profile
    profile_data.rule_invocations.should
    profile_data.guessing_rule_invocations.should
    profile_data.rule_invocation_depth.should

    profile_data.fixed_decisions.should
    fixed_data = profile_data.fixed_looks
    fixed_data.min.should
    fixed_data.max.should
    fixed_data.average.should
    fixed_data.standard_deviation.should

    profile_data.cyclic_decisions.should
    cyclic_data = profile_data.cyclic_looks
    cyclic_data.min.should
    cyclic_data.max.should
    cyclic_data.average.should
    cyclic_data.standard_deviation.should

    profile_data.syntactic_predicates.should

    profile_data.memoization_cache_entries.should
    profile_data.memoization_cache_hits.should
    profile_data.memoization_cache_misses.should

    profile_data.semantic_predicates.should
    profile_data.tokens.should
    profile_data.hidden_tokens.should
    profile_data.characters_matched.should
    profile_data.hidden_characters_matched.should
    profile_data.reported_errors.should == 0
  end
end
