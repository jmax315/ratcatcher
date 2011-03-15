require 'app/maybe_renamable'

class RenameItem < RefactoringProcessor
  include MaybeRenamable

  def initialize(old_name, new_name)
    super
  end
end
