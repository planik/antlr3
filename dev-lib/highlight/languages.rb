#!/usr/bin/ruby
module Highlight
  module Languages
    autoload :ANTLR, 'highlight/languages/antlr'
    autoload :Shell, 'highlight/languages/shell'
    autoload :Generic, 'highlight/languages/generic'
    autoload :Ruby, 'highlight/languages/ruby'
  end
end
