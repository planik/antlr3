#!/usr/bin/ruby

$:.unshift(File.dirname(__FILE__))
require 'FuzzyJava'

for file in ARGV
  input = ANTLR3::FileStream.new(file)
  FuzzyJava::Lexer.new(input).exhaust
end
