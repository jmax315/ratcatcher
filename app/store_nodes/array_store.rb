class ArrayStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @children= new_sexp[1..-1].map { | child | RatCatcherStore.from_sexp(child) }
    vars = new_sexp[1..-1].map {|v| v[1].to_s}.join(',')
    @text = "[#{vars}]"
  end

  def sexp
    s(:array, *sexplist_from_children)
  end
end
