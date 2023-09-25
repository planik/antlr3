#!/usr/bin/ruby
require 'spec/runner/formatter/progress_bar_formatter'

PrettyError.blacklist(__FILE__, 'rspec', 'timeout.rb')

class ::Spec::Runner::Formatter::ProgressBarFormatter
  remove_method :method_missing
end

module ANTLR3
  module Test
    class Formatter < ::Spec::Runner::Formatter::ProgressBarFormatter
      include Messages
      # just a little alias to keep things clean
      NoDice = Spec::Expectations::ExpectationNotMetError

      def initialize(options, where)
        super
        @summary = Summary.new
      end

      def example_passed(_example)
        @summary.passed += 1
        inform(PASSED)
      end

      def example_pending(_example, _message, _pending_caller)
        @summary.pending += 1
        inform(PENDING)
      end

      def example_failed(_example, _counter, failure)
        case failure.exception
        when Grammar::CompilationFailure then @summary.compilation_failures += 1
        when SyntaxError then @summary.syntax_errors += 1
        when ImportError then @summary.import_errors += 1
        when NoDice      then @summary.failed += 1
        else @summary.example_errors += 1
        end
        inform(FAILED)
      end

      def start_dump
        @where.print(DIVIDER)
        @where.flush
      end

      def dump_failure(counter, failure)
        @where.puts
        @where.puts "#{counter}) #{failure.example}"

        case error = failure.exception
        when Grammar::CompilationFailure
          @where.puts error.pretty!(backtrace: false)
        when NoDice
          @where.puts error.pretty!(backtrace: 1)
        when nil then super
        else
          @where.puts(error.pretty!)
        end

        @where.flush
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        ret = super
        @summary.duration = duration
        @where.print(DIVIDER)
        @where.print(@summary.serialize)
        @where.flush
        ret
      end

      def inform(message)
        @where.putc(message)
        @where.flush
      end

      #  add_example_group, close, dump_failure, dump_pending,
      #  dump_summary, example_failed, example_passed, example_pending,
      #  example_started, start, start_dump
    end

    class Runner < Spec::Runner::ExampleGroupRunner
      def initialize(options, *)
        super(options)
        Grammar.inform!
        @status = 0
      end

      def run
        prepare

        for example_group in example_groups
          example_group.run or @status = 2
        end

        failed = (@status & FAILURES).zero?
        !failed
      ensure
        finish
      end

      def finish
        super
        exit!(@status)
      end
    end
  end
end

# turns out rspec won't recognize "ANTLR3::Test::Formatter"
# as a command line option for formatter -- these are
# aliases to make it work

ANTLRFormatter = ANTLR3::Test::Formatter
ANTLRRunner = ANTLR3::Test::Runner
