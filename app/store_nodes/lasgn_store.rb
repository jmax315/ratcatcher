class LasgnStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].to_s
    @children << RatCatcherStore.from_sexp(new_sexp[2])
  end

  def sexp
    s(:lasgn, @text.to_sym, *sexplist_from_children )
  end

  def name
    @text
  end

  def rename(new_name)
    @text= new_name
  end
end
