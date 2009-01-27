#!/usr/bin/env ruby 

require 'ruby_parser'
require 'ruby2ruby'

toy_source=<<EOF
class Toy
  def a_func(x)
    if x == 0
      return 1
    else
      x * a_func(x-1)
    end
  end
end
EOF

print "toy_source: ", toy_source, "\n"

toy_tree= RubyParser.new.process toy_source
print "toy_tree:   ", toy_tree, "\n"

toy_output= Ruby2Ruby.new.process toy_tree
print "toy_output: ", toy_output, "\n"

print "toy_source: ", toy_source, "\n"
print "toy_tree:   ", toy_tree, "\n"
print "toy_output: ", toy_output, "\n"
