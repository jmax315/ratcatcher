require 'ruby_parser'
require 'ruby2ruby'


class RatCatcherStore
  attr_accessor :children
  attr_reader :listeners
    
  def self.parse source_code= ''
    @parse_tree= RubyParser.new.process source_code
    RatCatcherStore.new @parse_tree
  end

  def initialize sexp
    @sexp= sexp
    @children= []
    @listeners= []

    return if sexp == nil

    case sexp[0]
    when :str

    when :lit

    when :call
      if sexp[1]
        @children << RatCatcherStore.new(sexp[1])
      end

      sexp[3][1..-1].each do |arg|
        @children << RatCatcherStore.new(arg)
      end

    when :if
      @children= [RatCatcherStore.new(sexp[1]),
                  RatCatcherStore.new(sexp[2]),
                  RatCatcherStore.new(sexp[3])]

    when :defn
      block_node = sexp[3][1]
      block_node[1..-1].each do |node|
        @children << RatCatcherStore.new(node)
      end

    when :yield

    else
      raise "Unhandled sexp: #{sexp.inspect}"

    end
  end

  def sexp
    @sexp
  end

  def sexp= new_value
    @sexp= new_value
    @listeners.each {|listener| listener.store_changed(self) }
  end

  def add_listener(new_listener)
    @listeners << new_listener
  end

  def text
    if @sexp == nil
      return ""
    end
    
    case @sexp[0]
    when :str
      return @sexp[1].inspect
      
    when :lit
      return @sexp[1].inspect

    when :call
      return (@sexp[2] == :-@)? '-': @sexp[2].to_s

    when :if
      return '?:'

    when :defn
      return "def #{@sexp[1].to_s}"

    when :yield
      return"yield"
    end

    raise "RatCatcharStore#text: Unhandled @sexp: #{@sexp.inspect}"
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

