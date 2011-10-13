require File.expand_path(File.dirname(__FILE__)) + '/../maybe_renamable'

class RenameClass < RefactoringProcessor
  include MaybeRenamable

  def initialize(old_name, new_name)
    super
  end

  def process_class(sexp)
    discard_type(sexp)
    s(:class, maybe_rename(sexp.shift), process(sexp.shift), process(sexp.shift))
  end

  def process_const(sexp)
    discard_type(sexp)
    s(:const, maybe_rename(sexp.shift))
  end
end
