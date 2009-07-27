
#TODO Remove this hack
class RatCatcherStore
end


class LiteralStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1].inspect
  end

  #TODO sexp
end
