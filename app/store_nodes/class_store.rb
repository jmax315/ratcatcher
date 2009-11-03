class ClassStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)

    @text= new_sexp[1].to_s
    children_from_subexpressions(new_sexp[2..3])
  end

  def superclass
    @children[0]
  end

  def body
    @children[1]
  end

  def name
    @text
  end

  def sexp
    s(:class, name.to_sym, superclass.sexp, @children[1].sexp)
  end

end
