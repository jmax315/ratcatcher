require File.expand_path(File.dirname(__FILE__)) + '/var_ref_store'

class LasgnStore < VarRefStore
  def initialize(new_sexp)
    super(new_sexp)
    if new_sexp[2]
      @children << RatCatcherStore.from_sexp(new_sexp[2])
    end
  end

  def sexp
    s(:lasgn, @text.to_sym, *sexplist_from_children)
  end
end
