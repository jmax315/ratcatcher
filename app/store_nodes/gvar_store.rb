class GvarStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
  end

  def sexp
    s(:gvar, @text.to_sym)
  end
end
