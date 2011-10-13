require File.expand_path(File.dirname(__FILE__)) + '/../maybe_renamable'

class RenameMethod < RefactoringProcessor
  include MaybeRenamable

  def initialize(old_name, new_name)
    super
  end
  
  def process_defn(sexp)
    discard_type(sexp)
    s(:defn, maybe_rename(sexp.shift), process(sexp.shift), process(sexp.shift))
  end

  def process_call(sexp)
    discard_type(sexp)
    s(:call, process(sexp.shift), maybe_rename(sexp.shift), process(sexp.shift))
  end
end

# vim:sw=2:ai
