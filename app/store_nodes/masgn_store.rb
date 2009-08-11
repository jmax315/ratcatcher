class MasgnStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @children= [RatCatcherStore.from_sexp(new_sexp[1]),
                RatCatcherStore.from_sexp(new_sexp[2])]
  end

  def sexp
    s(:masgn, *sexplist_from_children)
  end
end
