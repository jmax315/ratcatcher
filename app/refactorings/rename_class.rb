require 'app/maybe_renamable'

class RenameClass < RefactoringProcessor
  include MaybeRenamable

  def initialize(old_name, new_name)
    super
  end

  def process_class(sexp)
    discard_type(sexp)
    s(:class, maybe_rename(sexp.shift), sexp.shift, sexp.shift)
  end
end
