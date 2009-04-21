require 'ruby_parser'
require 'ruby2ruby'


class RatCatcherStore
  attr_accessor :text, :sexp, :children
    
  def self.parse source_code= ''
    @parse_tree= RubyParser.new.process source_code
    RatCatcherStore.new @parse_tree
  end

  def initialize sexp
    @text= ""
    @children= []

    return if sexp == nil

    @sexp= sexp

    case sexp[0]
    when :str
      @text= sexp[1].inspect

    when :lit
      @text= sexp[1].inspect

    when :call
      @text= (sexp[2] == :-@)? '-': sexp[2].to_s

      if sexp[1]
        @children << RatCatcherStore.new(sexp[1])
      end

      sexp[3][1..-1].each do |arg|
        @children << RatCatcherStore.new(arg)
      end

    when :if
      @text= '?:'
      @children= [RatCatcherStore.new(sexp[1]),
                  RatCatcherStore.new(sexp[2]),
                  RatCatcherStore.new(sexp[3])]

    when :defn
      @text= "def #{sexp[1].to_s}"
      block_node = sexp[3][1]
      
      block_node[1..-1].each do |node|
        @children << RatCatcherStore.new(node)
      end

    when :yield
      @text= "yield"

    else
      raise "Unhandled sexp: #{sexp.inspect}"

    end
  end

  def ==(right)
    sexp == right.sexp
  end

  def to_s
    Ruby2Ruby.new.process(@sexp)
  end

  def [](index)
    @children[index]
  end

  def path_reference(path)
    path.split(':').inject(self) do |value, index|
      value= value[index.to_i]
    end
  end

end

