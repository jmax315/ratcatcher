require 'app/rat_catcher_store'

class RatCatcherStore
end


class DefnStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)

    @text= new_sexp[1].to_s
    @children= [RatCatcherStore.from_sexp(new_sexp[2]),
                RatCatcherStore.from_sexp(new_sexp[3])]
  end

  def init_block
    @children[0].init_block
  end

  def sexp
    s(:defn, @text.to_sym, s(:args), @children[1].sexp)
  end
end
