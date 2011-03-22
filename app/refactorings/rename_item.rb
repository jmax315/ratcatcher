require 'app/maybe_renamable'

# s(:call, nil, :require, s(:arglist, s(:str, "ferd")))

class RenameItem < RefactoringProcessor
  include MaybeRenamable

  def initialize(old_name, new_name)
    super
    @in_arglist= false
  end

  # def process_call(sexp)
  #   discard_type(sexp)
  #   object= sexp.shift
  #   method= sexp.shift
  #   args= sexp.shift
  #   s(:call, object, method, args)
  # end

  def process_str(sexp)
    discard_type(sexp)
    string= sexp.shift
    if (@in_require_call && @in_arglist && string == @old_name)
      s(:str, @new_name)
    else
      s(:str, string)
    end
  end

  def process_arglist(sexp)
    discard_type(sexp)
    @in_arglist= true
    new_sexp= s(:arglist)
    while (!sexp.empty?)
      new_sexp << process(sexp.shift)
    end
    @in_arglist= false
    new_sexp
  end

  def process_call(sexp)
    discard_type(sexp)
    object= process(sexp.shift)
    method= sexp.shift
    @in_require_call= (method == :require)
    args= process(sexp.shift)
    @in_require_call= false
    s(:call, object, method, args)
  end
end
