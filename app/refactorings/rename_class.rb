class RenameClass < RefactoringProcessor
   def initialize(old_name, new_name)
     super()
     @old_name= old_name
     @new_name= new_name
   end

   def process_class(sexp)
     if sexp[1] == @old_name.to_sym
       discard_type(sexp)
       sexp.shift
       s(:class, @new_name.to_sym, sexp.shift, sexp.shift)
     else
       s(sexp.shift, sexp.shift, sexp.shift, sexp.shift)
     end
   end
end
