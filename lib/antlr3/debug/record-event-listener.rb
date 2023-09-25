#!/usr/bin/ruby
module ANTLR3
  module Debug
    # rdoc ANTLR3::Debug::RecordEventListener
    #
    # A debug listener that records intercepted events as strings in an array.
    #
    class RecordEventListener < TraceEventListener
      attr_reader :events

      def initialize(adaptor = nil)
        super
        @events = []
      end

      def record(event_message, *interpolation_arguments)
        event_message = event_message.to_s
        @events << event_message % interpolation_arguments
      end
    end
  end # module Debug
end # module ANTLR3
