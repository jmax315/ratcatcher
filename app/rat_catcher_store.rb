require 'ruby_parser'
require 'ruby2ruby'

#Todo: make these absolute paths
require 'app/rename_variable'
require 'app/tree_like_matcher'


class RatCatcherStore
  attr_reader :sexp

  def self.parse source_code
    RatCatcherStore.from_sexp(RubyParser.new.process(source_code))
    rescue ParseError
  end

  def self.from_sexp new_sexp
    RatCatcherStore.new(new_sexp)
  end

  private
  
  def initialize new_sexp
    @sexp= new_sexp
  end

  public

  def ==(right)
    right.nil? ? false : @sexp == right.sexp
  end

  def to_ruby
    Ruby2Ruby.new.process(sexp)
  end

  def find(path)
    if !path
      return nil
    end
    path_components= path.split('/')
    walk(path_components)
  end

  def have_name?
    sexp[1]  &&  sexp[1].kind_of?(Symbol)
  end

  def name
    sexp[1].to_sym
  end

  def walk(path_components)
    if path_components.size < 1
      nil
    elsif !have_name?
      walk_children(path_components)
    elsif name != path_components[0]
      nil
    elsif path_components.size == 1
      self
    else
      walk_children(path_components[1..-1])
    end
  end

  def walk_children(path_components)
    @sexp.each do |sub_expression|
      if sub_expression.kind_of?(Sexp)
        sub_store= RatCatcherStore.from_sexp(sub_expression)
        sub_match= sub_store.walk(path_components)
        if sub_match
          return sub_match
        end
      end
    end
    nil
  end

  def has_name?
    @sexp && @sexp[0] == :class
  end

  def name
    @sexp[1].to_s
  end

  def matches?(expected_name)
    has_name?  &&  name == expected_name
  end

  def apply(refactoring, *args)
    the_refactoring= RenameVariable.new(args[0], args[1])
    @sexp= the_refactoring.process(@sexp)
  end
end
