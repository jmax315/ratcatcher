class IfStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @children= [RatCatcherStore.from_sexp(new_sexp[1]),
                RatCatcherStore.from_sexp(new_sexp[2]),
                RatCatcherStore.from_sexp(new_sexp[3])]
    @text= '?:'
  end

  def sexp
    s(:if, @children[0].sexp, @children[1].sexp, @children[2].sexp)
  end

end
