class VariableRename
  def initialize(old_name, new_name)
    @old_name= old_name
    @new_name= new_name
  end

  def apply(tree_store)
    tree_store.rename_variable(@old_name, @new_name)
    tree_store.children.each { |child| apply(child) }
  end
end
