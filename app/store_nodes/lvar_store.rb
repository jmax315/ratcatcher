require File.expand_path(File.dirname(__FILE__)) + '/var_ref_store'

class LvarStore < VarRefStore

  def initialize(new_sexp)
    super(new_sexp)
  end

  def sexp
    s(:lvar, @text.to_sym)
  end
end
