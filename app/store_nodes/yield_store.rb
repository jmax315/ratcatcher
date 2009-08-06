class YieldStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= "yield"
    @children= new_sexp[1..-1].map { |child| RatCatcherStore.from_sexp(child) }
  end

  def sexp
    s(:yield, *sexplist_from_children)
  end
end
