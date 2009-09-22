current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/block_store'

class ScopeStore < BlockStore
  def initialize(new_sexp)
    super(new_sexp)
  end

  def sexp
    s(:scope, *sexplist_from_children )
  end

  def matches(name, rest_of_path)
    @children.find {|kid| kid.matches(name, rest_of_path)}
  end
end
