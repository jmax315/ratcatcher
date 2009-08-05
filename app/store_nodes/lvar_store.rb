class LvarStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
  end

  def sexp
    s(:lvar, @text.to_sym )
  end

  def rename_variable(old_name, new_name)
    if @text == old_name
      @text= new_name
    end
  end
end
