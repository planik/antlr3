#!/usr/bin/ruby
module ANTLR3
  module Test
    class Grammar
      include Messages

      @@inform = false
      def self.inform!
        return if @inform

        @@inform = true
        class_eval(<<-END, __FILE__, __LINE__ + 1)
        alias compile_without_inform compile
        def compile( *args )
          out = compile_without_inform( *args )
          $stdout.print( '.' )
          $stdout.flush
          return out
        end
        END
      end

      def post_compile(options)
        if options[:debug_st]
          target_files.grep(/\.rb$/) do |path|
            StringTemplate::Markup.convert(path)
          end
        end

        return unless @@inform

        $stdout.putc(GRAMMAR_COMPILE)
        $stdout.flush
      end
    end

    # GrammarManager.add_default_compile_option( :debug_st, true )

    class Functional
      def self.import(ruby_file)
        super
      rescue StandardError => e
        raise ImportError, e
      end
    end

    class ImportError < StandardError
      attr_reader :error

      def initialize(error)
        @error = error
        super(@error.message)
        set_backtrace(@error.backtrace)
      end
    end
  end
end
