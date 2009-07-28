class NilStore < RatCatcherStore
  def initialize(dummy)
    super(nil)
  end

  def sexp
    nil
  end
end
