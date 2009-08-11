class ToAryStore < RatCatcherStore 
  def initialize(new_sexp)
    super(new_sexp)
    children_from_subexpressions(new_sexp[1..-1])
  end

  def sexp
    s(:to_ary, *sexplist_from_children)
  end
end
