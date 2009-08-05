class LvarStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
  end

  def sexp
    s(:lvar, @text.to_sym )
  end

  def name
    @text
  end

  def rename(new_name)
    @text= new_name
  end
end
