class LitStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @value= new_sexp[1]
    @text= @value.inspect
  end

  def sexp
    s(:lit, @value)
  end
end
