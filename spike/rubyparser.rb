#!/usr/bin/env ruby 

require 'ruby_parser'
require 'ruby2ruby'

toy_source= ARGV[0]

print "toy_source: ", toy_source, "\n\n"

toy_tree= RubyParser.new.process toy_source
print "toy_tree:   ", toy_tree, "\n\n"

toy_output= Ruby2Ruby.new.process toy_tree
print "toy_output: ", toy_output, "\n\n"
