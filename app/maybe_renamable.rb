module MaybeRenamable
   def initialize(old_name, new_name)
     super()
     @old_name= old_name
     @new_name= new_name
   end

   def maybe_rename(name)
     (@old_name == name.to_s) ? @new_name.to_sym : name
   end
end

