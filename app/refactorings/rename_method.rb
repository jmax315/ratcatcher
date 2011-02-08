class RenameMethod < RefactoringProcessor
  def initialize(old_name, new_name)
    super()
    @old_name= old_name
    @new_name= new_name
  end
  
  def process_defn(sexp)
    discard_type(sexp)
    s(:defn, maybe_rename(sexp.shift), sexp.shift, sexp.shift)
  end

  def process_call(sexp)
    discard_type(sexp)
    s(:call, sexp.shift, maybe_rename(sexp.shift), sexp.shift)
  end

  def maybe_rename(variable)
    (@old_name == variable.to_s) ? @new_name.to_sym : variable
  end

end

# vim:sw=2:ai
