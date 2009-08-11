class MasgnStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    children_from_subexpressions(new_sexp[1..2])
  end

  def sexp
    s(:masgn, *sexplist_from_children)
  end
end
