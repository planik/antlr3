#!/usr/bin/ruby
module ANTLR3
  module Test
    Summary = Struct.new(
      :passed, :pending, :failed, :example_errors, :import_errors,
      :syntax_errors, :compilation_failures, :duration
    )

    class Summary
      FIELDS           = members.map { |m| m.to_s }
      COUNT_FIELDS     = FIELDS - %w[duration]
      UNIT_TEST_FIELDS = members - %w[import_errors syntax_errors compilation_failures]

      def self.restore(serialized)
        new.restore(serialized)
      end

      DESCRIPTIONS = {
        'passed' => %w[passed green],
        'pending' => %w[pending yellow],
        'failed' => %w[failed red],
        'example_errors' => %w[error red],
        'import_errors' => %w[runtime magenta],
        'syntax_errors' => %w[syntax magenta],
        'compilation_failures' => %w[antlr magenta],
        nil => ['no tests', 'cyan']
      }

      def initialize(*args)
        members.length.times do |i|
          args[i] ||= 0
        end

        super(*args)
      end

      def serialize
        to_a.join(':')
      end

      def restore(serialized)
        fields = serialized.split(':')
        duration = fields.pop.to_f
        fields.map! { |i| i.to_i }.push(duration)
        fields.each_with_index do |value, i|
          self[i] = value
        end
        self
      end

      def total
        to_a[0...-1].inject(0) { |t, m| t + m }
      end

      def <<(sum)
        for field in members
          self[field] += sum[field]
        end
        self
      end

      def +(other)
        dup << other
      end

      def description(with_color = false)
        field = COUNT_FIELDS.reverse.find do |f|
          self[f] > 0
        end
        desc, color =
          DESCRIPTIONS.fetch(field.to_s, [field.to_s, 'blue'])
        with_color and desc = desc.send(color)

        desc
      end

      def report(opts = nil)
        if opts
          with_color = opts.fetch(:color, true)
          desc = opts[:description] || description(with_color)
        else
          desc = description(true)
        end

        format_fields([desc, total, *to_a])
      end

      def unit_test_report(opts = nil)
        if opts
          with_color = opts.fetch(:color, true)
          desc = opts[:description] || description(with_color)
        else
          desc = description(true)
        end

        values = UNIT_TEST_FIELDS.map { |f| self[f] }
        format_fields([desc, total, *values])
      end

      private

      def format_fields(values)
        values.map! do |v|
          case v
          when Float then '%0.4f' % v
          else v.to_s
          end
        end
      end
    end
  end
end
