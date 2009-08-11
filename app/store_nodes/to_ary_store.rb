class ToAryStore < RatCatcherStore 
  def initialize(new_sexp)
    super(new_sexp)
    @children= new_sexp[1..-1].map { | child | RatCatcherStore.from_sexp(child) }
  end

  def sexp
    s(:to_ary, *sexplist_from_children)
  end
end
