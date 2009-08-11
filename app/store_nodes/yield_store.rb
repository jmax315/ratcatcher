class YieldStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    children_from_subexpressions(new_sexp[1..-1])
    @text= "yield"
  end

  def sexp
    s(:yield, *sexplist_from_children)
  end
end
