class DefsStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)

    @text= new_sexp[2].to_s
    children_from_subexpressions([new_sexp[1], new_sexp[3], new_sexp[4]])
  end

  def sexp
    s(:defs,
      @children[0].sexp,
      @text.to_sym,
      s(:args) + @children[1].argument_names,
      @children[2].sexp)
  end
end
