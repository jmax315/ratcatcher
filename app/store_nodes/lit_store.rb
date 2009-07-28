class LitStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].inspect
  end

  #TODO sexp
end
