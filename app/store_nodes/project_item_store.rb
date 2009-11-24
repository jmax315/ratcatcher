class ProjectItemStore
  attr_reader :name

  def initialize(name, store)
    @store= store
    @name= name
  end

  def to_ruby
    @store.to_ruby
  end

  def sexp
    @store.sexp
  end

  def find(path)
    if !path || path == "" || path == '.'
      return self
    end
    
    first_path_element, rest_of_path = path.split("/", 2)

#     if first_path_element == "."
#       return find(rest_of_path)
#     end

    @store.matches(first_path_element, rest_of_path)
  end

  def apply(refactoring, *args)
    @store.apply(refactoring, *args)
  end
end

