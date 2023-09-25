#!/usr/bin/ruby
module Highlight
  module Formatters
    module HTML
      class TokenSpan
        include Taggable
        attr_accessor :type, :text, :link, :attributes

        def []=(name, value)
          @attributes ||= {}
          @attributes[name.to_s] = value ? value.to_s : value
        end

        def [](name)
          @attributes ? @attributes[name.to_s] : nil
        end

        def initialize(group, type, text, options = nil)
          @group = group
          @type = type
          @text = text
          return unless options

          @link = options.delete(:link)
          @attributes = options
        end

        def to_s
          t = ''
          @link and t << anchor
          t << %(<span #{attribute_string}>#{escape(@text)}</span>)
          @link and t << '</a>'
          t
        end

        private

        def attribute_string
          t = class_attribute(@type)
          @attributes and @attributes.each do |name, value|
            value and t << %( #{name}=%p) % value.to_s
          end
          t
        end

        def anchor
          line_id = @group.generate_id(@link)
          %(<a href="##{line_id}">)
        end

        def escape(text)
          text = CGI.escapeHTML(text.to_s)
          text.gsub!(/ /, '&nbsp;')
          text
        end
      end
    end
  end
end
