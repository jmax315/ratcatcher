class ScopeStore < BlockStore
  def initialize(new_sexp)
    super(new_sexp)
  end

  def sexp
    s(:scope, *sexplist_from_children )
  end
end
