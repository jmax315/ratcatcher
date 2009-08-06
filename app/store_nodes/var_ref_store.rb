class VarRefStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
  end

  def rename_variable(old_name, new_name)
    if @text == old_name
      @text= new_name
    end
  end
end
