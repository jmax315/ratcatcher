#!/usr/bin/env ruby 

require 'ripper'
require 'pp'

toy_source= if (ARGV[0])
              ARGV[0]
            else
              $stdin.read
            end

#puts "toy_source: #{toy_source}\n"

class MyRipper < Ripper
  def initialize(*args)
    super(*args)
  end

  PARSER_EVENTS.each do |event|
    eval <<-End
      def on_#{event}(*args)
        args.unshift :#{event}
        args
      end
      End
  end

  SCANNER_EVENTS.each do |event|
      eval <<-End
      def on_#{event}(tok)
        tok
      end
      End
  end
end

def re_source(ptree)
  puts "re_source(#{ptree.inspect})"
  source= ptree[1..-2].inject('') do |s, subtree|
    s + re_source(subtree)
  end
  source + ptree[-1].join('')
end

tree= MyRipper.new(toy_source).parse
pp tree
puts re_source(tree)
