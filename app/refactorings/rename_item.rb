require_relative '../refactoring_processor'
require_relative '../maybe_renamable'
require_relative '../rat_catcher_exception'

# Here's what a parsed call looks like.
# s(:call, nil, :require, s(:arglist, s(:str, "ferd")))

class RenameItem < RefactoringProcessor
  include MaybeRenamable

  def initialize(old_name, new_name, item_name, *options)
    super(old_name, new_name)
    @item_name= item_name
    @options= {}

    options.each do |an_option|
      if an_option.kind_of?(Hash)
        @options.merge!(an_option)
      else
        @options[an_option]= true
      end
    end
  end

  def is_same_file(reference)
    current_source_file_directory= File.dirname(@item_name)
    absolute_reference= File.expand_path(reference, current_source_file_directory)
    absolute_reference == @old_name
  end


  def process_arglist(sexp)

    sexp_clone = Sexp.from_array(sexp.to_a)

    discard_type(sexp)
    if @in_require_call
      the_file = sexp.shift

      if the_file == File.expand_path('.', @old_name) ||
         the_file == "#{File.expand_path('.', @old_name)}.rb"
        s(:arglist,
          s(:call,
            s(:call,
              s(:const, :File),
              :dirname,
              s(:arglist, s(:const, :__FILE__))),
            :+,
            s(:arglist, s(:str,"/" + @new_name))))
      else
        sexp_clone
      end
    else
      new_sexp= s(:arglist)
      while (!sexp.empty?)
        new_sexp << process(sexp.shift)
      end
      new_sexp
    end
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
