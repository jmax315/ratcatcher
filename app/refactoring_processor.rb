class RefactoringProcessor
  def initialize
    super()
  end
 
  def discard_type(sexp)
    sexp.shift
  end
end
