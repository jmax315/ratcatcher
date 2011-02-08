#require 'ruby_parser'
require 'sexp_processor'

class RefactoringProcessor < SexpProcessor
  def initialize
    super()
  end
 
  def discard_type(sexp)
    sexp.shift
  end

  def maybe_rename(name)
    (@old_name == name.to_s) ? @new_name.to_sym : name
  end

end

# vim:sw=2:ai
