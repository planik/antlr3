#!/usr/bin/ruby
require 'redcloth'
require 'highlight'
require 'erb'
require 'yaml'
require 'inflection'
autoload :OpenStruct, 'ostruct'

module ANTLRDoc
  WIKI_LINK_RX = /
    ‹
    ( (?:\S|\ (?=\S))+? )
    (?: : \ ? ( (?:\S|\ (?=\S))+? ) )?
    ›
  /x

  REGION = /
    ^(
      « \ * (\S+) \ * \n    # tag line:     « ruby
        (.*?) \n            # body:         some = ruby.code
      » \ * \n              # closing line: »
    )
  /mx
end

require 'doc-utils/markup'
require 'doc-utils/guide'
require 'doc-utils/code-frame'
require 'doc-utils/table'
