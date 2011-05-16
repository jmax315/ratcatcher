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

  def is_same_file(reference)
    current_source_file_directory= File.dirname(@item_name)
    absolute_reference= File.expand_path(reference, current_source_file_directory)
    absolute_reference == @old_name
  end

  def process_str(sexp)
    discard_type(sexp)
    string= sexp.shift

    # puts "RenameItem#process_str:"
    # puts "       string: #{string.inspect}"
    # puts "    @in_require_call: #{@in_require_call}"
    # puts "    @in_arglist: #{@in_arglist}"
    # puts "    @old_name: #{@old_name}"
    # puts "    @new_name: #{@new_name}"
    # puts

    return s(:str, string) unless (@in_require_call && @in_arglist)

    string.gsub!(/^#{Regexp.escape(@old_name)}$/, @new_name)
    string.gsub!(/\/#{Regexp.escape(@old_name)}$/, '/' + @new_name)

    string.gsub!(/^#{Regexp.escape(@old_name)}.rb$/, @new_name + '.rb')
    string.gsub!(/\/#{Regexp.escape(@old_name)}.rb$/, '/' + @new_name + '.rb')

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
    old_in_require_call= @in_require_call
    @in_require_call ||= (method == :require)
    args= process(sexp.shift)
    @in_require_call= old_in_require_call
    s(:call, object, method, args)
  end
end
