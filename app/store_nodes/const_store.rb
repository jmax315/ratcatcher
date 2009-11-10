class ConstStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
  end

  def sexp
    s(:const, @text.to_sym)
  end
end