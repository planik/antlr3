#!/usr/bin/ruby
#      ::about::
# author:     Kyle Yetter <kcy5b@yahoo.com>
# created on: January 10, 2011
# purpose:    (program | library | utility script | ?)
# summary:
# loads:      files required by this
# autoloads:  autoload entries in this (e.g. YAML(yaml))

__DIR__ = File.dirname(__FILE__)
$:.unshift File.expand_path(File.join(__DIR__, '../../../lib'))
require './SearchExpressionParser'

parser = SearchExpression::Parser.new('a and b or c and not d')

return_val = parser.search_expression

tree = return_val.tree

dot = ANTLR3::DOT::TreeGenerator.generate(tree)
puts dot
