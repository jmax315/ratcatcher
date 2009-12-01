class ResbodyStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    children_from_subexpressions(new_sexp[1..2])
  end

  def sexp
    s(:resbody, children[0].sexp, children[1].sexp)
  end
end
