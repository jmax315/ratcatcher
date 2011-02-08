class RenameClass < RefactoringProcessor
   def initialize(old_name, new_name)
     super()
     @old_name= old_name
     @new_name= new_name
   end

   def process_class(sexp)
     discard_type(sexp)
     s(:class, maybe_rename(sexp.shift), sexp.shift, sexp.shift)
   end
end
