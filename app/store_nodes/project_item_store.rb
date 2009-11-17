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
    @store.find(path)
  end

  def apply(refactoring, *args)
    @store.apply(refactoring, *args)
  end
end

