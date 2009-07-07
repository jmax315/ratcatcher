require 'ruby_parser'
require 'ruby2ruby'


class RatCatcherStore
  attr_accessor :children
  attr_reader :text

  def self.parse source_code
    RatCatcherStore.from_sexp(RubyParser.new.process(source_code))
  end

  def self.from_sexp new_sexp
    if new_sexp == nil
      return NilStore.new
    end
    
    case new_sexp[0]
    when :call
      CallStore.new(new_sexp)
    when :if
      IfStore.new(new_sexp)
    when :defn
      DefineStore.new(new_sexp)
    when :str
      StringStore.new(new_sexp)
    when :lit
      LiteralStore.new(new_sexp)
    when :yield
      YieldStore.new(new_sexp)
    when :lasgn
      LeftAssignStore.new(new_sexp)
    when :masgn
      MultipleAssignStore.new(new_sexp)     
    when :args
      ArgListStore.new(new_sexp)
    when :scope
      BlockStore.new(new_sexp)
    when :array
      ArrayStore.new(new_sexp)
    when :block
      BlockStore.new(new_sexp)
    when :nil
      NilStore.new
    else
      raise "RatCatcherStore#from sexp: unknown sort of sexp: #{new_sexp}"
    end
  end

  private
  
  def initialize new_sexp
    @children= []
    @text= ''
    @sexp= new_sexp
  end

  def sexplist_from_children
    @children[0..-1].map {|child| child.sexp}
  end

  public

  def replace_node(path, new_text)
    if path.size == 0
      RatCatcherStore.from_sexp(s(:call, sexp[1], new_text.to_sym, sexp[3]))
    else
      @children[path[0]]= @children[path[0]].replace_node(path[1..-1], new_text)
      self
    end
  end

  def sexp
      @sexp
  end

  def ==(right)
    sexp == right.sexp
  end

  def to_ruby
    Ruby2Ruby.new.process(@sexp)
  end

  def size
    @children.size
  end

  def [](index)
    @children[index]
  end

  def path_reference(path)
    path.inject(self) do |value, index|
      value= value[index]
    end
  end
end



class NilStore < RatCatcherStore
  def initialize
    super(nil)
  end

  def sexp
    nil
  end
end


class CallStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)

    @children << RatCatcherStore.from_sexp(new_sexp[1])
    
    if new_sexp[3].size > 1
      new_sexp[3][1..-1].each do |arg|
        @children << RatCatcherStore.from_sexp(arg)
      end
    end

    @text= (new_sexp[2] == :-@)? '-': new_sexp[2].to_s
  end


  def method_selector
    (@children.size == 1  &&  text == '-') ? :-@ :  text.to_sym
  end

  def arguments
    s(:arglist, *sexplist_from_children[1..-1] )
  end

  def receiver
    @children[0].sexp
  end

  def sexp
    s(:call, receiver, method_selector, arguments)
  end
end
  

class IfStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @children= [RatCatcherStore.from_sexp(new_sexp[1]),
                RatCatcherStore.from_sexp(new_sexp[2]),
                RatCatcherStore.from_sexp(new_sexp[3])]
    @text= '?:'
  end

  def sexp
    s(:if, @children[0].sexp, @children[1].sexp, @children[2].sexp)
  end

end


class DefineStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
    @children= [RatCatcherStore.from_sexp(new_sexp[2]),
                RatCatcherStore.from_sexp(new_sexp[3])]
  end

  def init_block
    @children[0].init_block
  end

  #TODO sexp
end

class StringStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1]
  end

  def sexp
    s(:str, @text)
  end
end


class LiteralStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].inspect
  end

  #TODO sexp
end

class YieldStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= "yield"
  end

  #TODO sexp
end


class LeftAssignStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= "#{new_sexp[1].to_s} = #{new_sexp[2][1]}"
  end

  #TODO sexp
end

class MultipleAssignStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    vars = new_sexp[1][1..-1].map {|v| v[1].to_s}.join(',')
    # TODO: Refactor this method...
    
    # Create children here....
    
    # Use them to create the @text value...
    if new_sexp[2][0] == :to_ary
      vals = new_sexp[2][1][1..-1].map {|v| v[1].to_s}.join(',')      
      @text= "#{vars} = [#{vals}]"
    else
      vals = new_sexp[2][1..-1].map {|v| v[1].to_s}.join(',')
      @text= "#{vars} = #{vals}"
    end
  end
end

class ArgListStore < RatCatcherStore
  attr_accessor :argument_names, :init_block

  def initialize(new_sexp)
    super(new_sexp)
    @init_block= nil
    if (!new_sexp[-1].is_a?(Symbol)) then
      @init_block= RatCatcherStore.from_sexp(new_sexp[-1])
      new_sexp= new_sexp[0..-2]
    end
    @argument_names= new_sexp[1..-1].to_a
  end

  #TODO sexp
end

class BlockStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @children= new_sexp[1..-1].map do |node|
      RatCatcherStore.from_sexp(node)
    end
  end

  def sexp
    s(:block, *sexplist_from_children )
  end
end

class ArrayStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @children= new_sexp[1..-1].map { | child | RatCatcherStore.from_sexp(child) }
    vars = new_sexp[1..-1].map {|v| v[1].to_s}.join(',')
    @text = "[#{vars}]"
  end
end
