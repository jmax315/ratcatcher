class VarRefStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
    if new_sexp[2]
      @children << RatCatcherStore.from_sexp(new_sexp[2])
    end
  end

  def rename_variable(old_name, new_name)
    if @text == old_name
      @text= new_name
    end
  end

  def sexp
    s(store_type, @text.to_sym, *sexplist_from_children )
  end
end
