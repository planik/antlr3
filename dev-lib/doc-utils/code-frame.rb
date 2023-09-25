#!/usr/bin/ruby
#      ::about::
# author:     Kyle Yetter <kcy5b@yahoo.com>
# created on: June 05, 2010
# purpose:    (program | library | utility script | ?)
# summary:
# loads:      files required by this
# autoloads:  autoload entries in this (e.g. YAML(yaml))

module ANTLRDoc
  class CodeFrame
    include Markup

    attr_accessor :language, :body

    def initialize(language, source, options = {})
      @header = @footer = nil
      @naked = options.fetch(:naked, false)

      if source =~ /\A(.+?)\n={3,}\n(.+)/m
        @header = ::Regexp.last_match(1)
        source = ::Regexp.last_match(2)
        options[:line] and options[:line] += @header.count($/) + 2
        @header.strip!
      end
      if source =~ /\A(.+?)\n-{3,}\n(.+)/m
        source = ::Regexp.last_match(1)
        @footer = ::Regexp.last_match(2).strip
      end

      @body =
        case @language = language
        when :antlr
          Highlight::Languages::ANTLR.new(source, options)
        when :ruby
          Highlight::Languages::Generic.new('ruby', source, options)
        when :css
          Highlight::Languages::Generic.new('css', source, options)
        when :cmd, :shell
          Highlight::Languages::Shell.new(source, options)
        end
    end

    def to_s
      eval_template(<<-'END'.fixed_indent(0).strip)
      <notextile>
      <div class="<%= @naked ? 'naked-code-frame' : 'code-frame' %>">
      % if @header
        <div class="code-header"><%= markup( @header ) %></div>
      % end
        <%= @body %>
      % if @footer
        <div class="code-footer"><%= markup( @footer ) %></div>
      % end
      </div>
      </notextile>
      END
    end
  end
end
