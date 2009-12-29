require 'ruby_parser'
require 'ruby2ruby'

#Todo: make these absolute paths
require 'app/rename_variable'
require 'app/always_matcher'
require 'app/tree_like_matcher'


class RatCatcherStore
  attr_accessor :children
  attr_reader :text, :sexp

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
    @text= ''
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

  def mk_path_matcher(path)
    if !path  || path == '' || path == '.'
      return AlwaysMatcher.new
    end

    first_path_element, rest_of_path = path.split("/", 2)

    if first_path_element == '.'
      path= rest_of_path
    end

    TreeLikeMatcher.new(s(:defn, path.to_sym, :_, :_))
  end

  def find(what)
    if what.respond_to?(:matches?)
      matcher= what
    else
      matcher= mk_path_matcher(what)
    end

    if matcher.matches?(@sexp)
      return self
    end

    @sexp.each do |child|
      if child.is_a?(Sexp)
        child_match= RatCatcherStore.from_sexp(child).find(matcher)
        if child_match
          return child_match
        end
      end
    end
    nil
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
