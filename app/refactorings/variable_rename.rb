class VariableRename
  def initialize(old_name, new_name)
    @old_name= old_name
    @new_name= new_name
  end

  def apply(tree_store)
    if tree_store.name==@old_name
      tree_store.rename(@new_name)
    end
  end
end
