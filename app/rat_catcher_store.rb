require 'ruby_parser'
require 'ruby2ruby'


class RatCatcherStore
  attr_accessor :children
  attr_reader :listeners, :text

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
    else
      RatCatcherStore.new(new_sexp)
    end
  end

  private
  
  def initialize new_sexp
    @children= []
    @listeners= []
    @text= ''
    @sexp= new_sexp
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

  def to_s
    Ruby2Ruby.new.process(@sexp)
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


  def sexp
    case @children.size
    when 0
      s(:call, nil, text.to_sym, s(:arglist))
    when 1
      if text == "-"
        s(:call, @children[0].sexp, :-@, s(:arglist))
      else
        s(:call, @children[0].sexp, text.to_sym, s(:arglist))
      end
    else
      s(
        :call,
        @children[0].sexp,
        text.to_sym,
        s(:arglist, *@children[1..-1].map {|child| child.sexp} )
       )
    end
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
    block_node = new_sexp[3][1]
    block_node[1..-1].each do |node|
      @children << RatCatcherStore.from_sexp(node)
      @text= "def #{new_sexp[1].to_s}"
   end

  end

end


class StringStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].inspect
  end

end


class LiteralStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].inspect
  end
end

class YieldStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= "yield"
  end

end


class LeftAssignStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= "#{new_sexp[1].to_s} = #{new_sexp[2][1]}"
  end
end
