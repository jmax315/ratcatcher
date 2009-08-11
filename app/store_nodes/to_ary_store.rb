class ToAryStore < ArrayStore
  def initialize(new_sexp)
    super(new_sexp)
  end

  def sexp
    s(:to_ary, *sexplist_from_children)
  end
end
