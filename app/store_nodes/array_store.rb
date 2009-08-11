class ArrayStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    children_from_subexpressions(new_sexp[1..-1])
    vars = new_sexp[1..-1].map {|v| v[1].to_s}.join(',')
    @text = "[#{vars}]"
  end

  def sexp
    s(:array, *sexplist_from_children)
  end
end
