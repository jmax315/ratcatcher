require 'ruby_parser'
require 'sexp_processor'
require 'app/maybe_renamable'

class RenameVariable < RefactoringProcessor
  include MaybeRenamable

  def initialize(old_name, new_name)
    super
  end
 
  def process_lasgn(sexp)
    discard_type(sexp)
    s(:lasgn,
      maybe_rename(sexp.shift),
      process(sexp.shift)
      )
  end

  def process_iasgn(sexp)
    discard_type(sexp)
    s(:iasgn,
      maybe_rename(sexp.shift),
      process(sexp.shift)
      )
  end

  def process_lvar(sexp)
    discard_type(sexp)
    s(:lvar,
      maybe_rename(sexp.shift)
      )
  end

  def process_args(sexp)
    discard_type(sexp)

    new_sexp= s(:args)
    while (!sexp.empty?)
      new_sexp << maybe_rename(sexp.shift)
    end

    new_sexp
  end
end

# vim:sw=2:ai
