class DefnStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)

    @text= new_sexp[1].to_s
    children_from_subexpressions(new_sexp[2..3])
  end

  def init_block
    @children[0].init_block
  end

  def sexp
    s(:defn,
      @text.to_sym,
      s(:args) + @children[0].argument_names,
      @children[1].sexp)
  end

   def name
     @text
   end
end
