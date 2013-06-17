require 'parser/current'

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

  def refactor(name, *args)
    @store.refactor(name, *args)
  end
end

