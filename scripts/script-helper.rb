#!/usr/bin/env ruby
__DIR__ = File.dirname(__FILE__)
project_top = File.dirname(__DIR__)
load File.join(project_top, 'config', 'antlr3.rb')

$project.load_environment
