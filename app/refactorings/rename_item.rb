require 'app/refactoring_processor'
require 'app/maybe_renamable'

# s(:call, nil, :require, s(:arglist, s(:str, "ferd")))

class RenameItem < RefactoringProcessor
  include MaybeRenamable

  def initialize(old_name, new_name, item_name)
    super(old_name, new_name)
    @item_name= item_name
    @in_arglist= false
  end

  def normalize(path)
    path
  end

  def is_same_file(reference)
    current_source_file_directory= File.dirname(@item_name)
    absolute_reference= File.expand_path(reference, current_source_file_directory)
    absolute_reference == @old_name
  end

  def relative_file_name(reference)
    @new_name
  end

  def process_str(sexp)
    discard_type(sexp)
    string= sexp.shift

    return s(:str, string) unless (@in_require_call && @in_arglist)

    string.gsub!(/^#{Regexp.escape(normalize(@old_name))}$/, @new_name)
    string.gsub!(/^#{Regexp.escape(normalize(@old_name))}.rb$/, @new_name + '.rb')

    s(:str, string)
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
