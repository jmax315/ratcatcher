class ArgsStore < RatCatcherStore
  attr_accessor :argument_names, :init_block

  def initialize(new_sexp)
    super(new_sexp)
    @init_block= nil
    if (!new_sexp[-1].is_a?(Symbol)) then
      @init_block= RatCatcherStore.from_sexp(new_sexp[-1])
      new_sexp= new_sexp[0..-2]
    end
    @argument_names= new_sexp[1..-1].to_a
  end

  #TODO sexp
end