class ProjectItemStore
  attr_reader :name

  def initialize(name, store)
    @store= store
    @name= name
  end

  def source
    @store.source
  end

  def sexp
    @store.sexp
  end

  def find(path)
    if !path || path == "" || path == '.'
      return self
    end
    
    first_path_element, rest_of_path = path.split("/", 2)

    if first_path_element != @name
      return nil
    elsif rest_of_path
      return @store.find(rest_of_path)
    else
      return self
    end
  end


  def apply(refactoring, *args)
    @store.apply(refactoring, *args)
  end
end

