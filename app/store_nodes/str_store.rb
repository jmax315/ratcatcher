class StrStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    @text= new_sexp[1]
  end

  def sexp
    s(:str, @text)
  end
end
