#!/usr/bin/ruby
module StringTemplate
  class Group
    class Template < Member
      Parameter = Struct.new(:name, :value) do
        def to_s
          if value.nil?
            name.to_s
          else
            [name, value.inspect].join('=')
          end
        end
      end

      def parameters
        @parameters ||= []
      end

      def parameter!(name, value = nil)
        param = Parameter[name, value]
        parameters << param
        param
      end

      def lex!(filter = false)
        TemplateLexer.new(body, location: body_start).lex!(filter)
      end

      def body_token
        defined?(@body_token) and return(@body_token)
        tokens.last
      end

      def body
        text = body_token.text
        case text
        when /^<<[ \t]*\n?(.*)\n?[ \t]*>>$/m then ::Regexp.last_match(1)
        when /^"(.*)"$/m then ::Regexp.last_match(1).gsub(/\\"/, '"')
        else text
        end
      end

      def body_start
        token = body_token
        location = token.location
        case token.text
        when /^(<<[ \t]*\n?)$/, /^(")/ then location + ::Regexp.last_match(1)
        else location
        end
      end

      def body_end
        token    = body_token
        location = token.location + token.text
        case token.text
        when /(\n?[ \t]*>>)$/, /(")$/ then location - ::Regexp.last_match(1)
        else location
        end
      end

      def alias!(name)
        TemplateAlias.new(self, name)
      end
    end
  end
end
