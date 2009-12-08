require 'ruby_parser'
require 'sexp_processor'

class VariableRenameProcessor < SexpProcessor
  def initialize(old_name, new_name)
    super()
    @old_name= old_name
    @new_name= new_name
  end

  def process_lasgn(sexp)
    p sexp
    type= sexp.shift
    name= sexp.shift.to_s
    if (@old_name == name)
      name = @new_name
    end
    s(:lasgn, name.to_sym, process(sexp.shift))
  end
end

# vim:sw=2:ai
