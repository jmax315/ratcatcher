class IterStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    children_from_subexpressions(new_sexp[1..3])
  end

  def sexp
    s(:iter, children[0].sexp, children[1].sexp, children[2].sexp)
  end
end
