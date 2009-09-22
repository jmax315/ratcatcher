class ConstStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
  end
end
