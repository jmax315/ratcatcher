require 'ruby_parser'
require 'ruby2ruby'

#Todo: make these absolute paths
require 'app/rename_variable'
require 'app/tree_like_matcher'


class RatCatcherStore
  attr_accessor :children
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
    @children= []
    @sexp= new_sexp
  end

  public

  def ==(right)
    right.nil? ? false : @sexp == right.sexp
  end

  def to_ruby
    Ruby2Ruby.new.process(sexp)
  end

  def size
    @children.size
  end

  def [](index)
    @children[index]
  end

  def find(path)
    if !path || path == '' || path == '.'
      return self
    end
    path_components= path.split('/')
    walk(path_components)
  end

  def walk(path_components)
    if path_components.size < 1
      return nil
    end

    if path_components[0] == '.'  ||
        TreeLikeMatcher.new(s(:_, path_components[0].to_sym, :*)).matches?(self.sexp)
      if path_components.size < 2
        return self
      end

      sub_components= path_components[1..-1]
      @sexp[2..-1].each do |sub_expression|
        if sub_expression.kind_of?(Sexp)
          sub_store= RatCatcherStore.from_sexp(sub_expression)
          sub_match= sub_store.walk(sub_components)
          if sub_match
            return sub_match
          end
        end
      end
    else
      @sexp[1..-1].each do |sub_expression|
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

#     if first_path_element == "."
#       return find(rest_of_path)
#     end

#     find_child_match(first_path_element, rest_of_path)
#  end

#   def find_child_match(first_path_element, rest_of_path)
#     @children.each do |kid|
#       kid_match= kid.matches(first_path_element, rest_of_path)
#       return kid_match if kid_match
#     end
#     nil
#   end

#   def matches(first_path_element, rest_of_path)
#     if respond_to?(:name)
#       if first_path_element != name
#         nil
#       elsif rest_of_path
#         find(rest_of_path)
#       else
#         self
#       end
#     else
#       find_child_match(first_path_element, rest_of_path)
#     end
#   end

#   def path_reference(path)
#     path.inject(self) do |value, index|
#       value= value[index]
#     end
#   end
  
  def apply(refactoring, *args)
    the_refactoring= RenameVariable.new(args[0], args[1])
    @sexp= the_refactoring.process(@sexp)
  end
end
