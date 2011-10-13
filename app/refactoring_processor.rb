require File.expand_path(File.dirname(__FILE__)) + '/ripper_sexp_processor'

class RefactoringProcessor < SexpProcessor
  def initialize
    super()
  end
 
  def discard_type(sexp)
    sexp.shift
  end
end

# vim:sw=2:ai
