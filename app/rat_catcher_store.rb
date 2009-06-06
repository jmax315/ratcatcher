require 'ruby_parser'
require 'ruby2ruby'


class RatCatcherStore
  attr_accessor :children
  attr_reader :listeners

  def self.parse source_code
    RatCatcherStore.from_sexp(RubyParser.new.process(source_code))
  end

  def self.from_sexp new_sexp
    OldRatCatcherStore.new(new_sexp)
  end
end


class OldRatCatcherStore < RatCatcherStore

  def initialize new_sexp
    @sexp= new_sexp
    @type= (new_sexp == nil) ? :nil : new_sexp[0]
    @listeners= []
    update_children
    set_text
  end

  def update_children
    @children= []

    case @type
    when :str

    when :lit

    when :call
      @children << RatCatcherStore.from_sexp(@sexp[1])

      if @sexp[3].size > 1
        @sexp[3][1..-1].each do |arg|
          @children << RatCatcherStore.from_sexp(arg)
        end
      end

    when :if
      @children= [RatCatcherStore.from_sexp(@sexp[1]),
                  RatCatcherStore.from_sexp(@sexp[2]),
                  RatCatcherStore.from_sexp(@sexp[3])]

    when :defn
      block_node = @sexp[3][1]
      block_node[1..-1].each do |node|
        @children << RatCatcherStore.from_sexp(node)
      end

    when :yield

    end
  end

  def replace_node(path, new_text)
    node= path_reference(path)
    new_sexp= s(:call, node.sexp[1], new_text.to_sym, node.sexp[3])
    node.sexp= new_sexp
    self
  end

  def sexp
    case @type
    when :nil
      nil

    when :call
      case @children.size
      when 0
        s(:call, nil, text.to_sym, s(:arglist))
      when 1
        if text == "-"
          s(:call, @children[0].sexp, :-@, s(:arglist))
        else
          s(:call, @children[0].sexp, text.to_sym, s(:arglist))
        end
      when 2
        s(:call, @children[0].sexp, text.to_sym, s(:arglist, @children[1].sexp))
      when 3
        s(:call, @children[0].sexp, text.to_sym, s(:arglist, @children[1].sexp, @children[2].sexp))
      when 4
        s(:call, @children[0].sexp, text.to_sym, s(:arglist, @children[1].sexp, @children[2].sexp, @children[3].sexp))
      else
        @sexp
      end
    else
      @sexp
    end
  end

  def sexp= new_value
    @sexp= new_value
    @type= (new_value == nil) ? :nil : new_value[0]
    update_children
    set_text
    @listeners.each {|listener| listener.store_changed(self) }
  end

  def add_listener(new_listener)
    @listeners << new_listener
  end

  def text
    @text
  end

  def set_text
    @text= ''
      
    case @type
    when :str
      @text= @sexp[1].inspect
      
    when :lit
      @text= @sexp[1].inspect

    when :call
      @text= (@sexp[2] == :-@)? '-': @sexp[2].to_s

    when :if
      @text= '?:'

    when :defn
      @text= "def #{@sexp[1].to_s}"

    when :yield
      @text="yield"
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



