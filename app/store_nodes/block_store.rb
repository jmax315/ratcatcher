class BlockStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @children= new_sexp[1..-1].map do |node|
      RatCatcherStore.from_sexp(node)
    end
  end

  def sexp
    s(:block, *sexplist_from_children )
  end
end

