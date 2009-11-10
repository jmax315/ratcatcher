class SelfStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
  end

  def sexp
    s(:self)
  end
end
