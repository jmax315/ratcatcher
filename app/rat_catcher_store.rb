require 'ruby_parser'
require 'ruby2ruby'

require File.expand_path(File.dirname(__FILE__)) + '/rename_variable'
require File.expand_path(File.dirname(__FILE__)) + '/tree_like_matcher'


class RatCatcherStore
end

class TopStore < RatCatcherStore
  attr_accessor :sexp

  def initialize(a_sexp)
    self.sexp= a_sexp
  end
end

class InternalStore < RatCatcherStore
  def initialize(parent_sexp, child_index)
    @parent_sexp= parent_sexp
    @child_index= child_index
  end

  def sexp
    @parent_sexp[@child_index]
  end

  def sexp=(new_value)
    @parent_sexp[@child_index]= new_value
  end
end

class RatCatcherStore
  def self.parse source_code
    TopStore.new(RubyParser.new.process(source_code))
    rescue ParseError
  end

  public

  def ==(right)
    right.nil? ? false : self.sexp == right.sexp
  end

  def source
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
    (1..self.sexp.size).each do |index|
      sub_expression= self.sexp[index]
      if sub_expression.kind_of?(Sexp)
        sub_store= InternalStore.new(self.sexp, index)
        sub_match= sub_store.walk(path_components)
        if sub_match
          return sub_match
        end
      end
    end
    nil
  end

  def name
    self.sexp[1].to_s
  end

  def apply(refactoring, *args)
    the_refactoring= RenameVariable.new(args[0], args[1])
    self.sexp= the_refactoring.process(self.sexp)
  end
end
