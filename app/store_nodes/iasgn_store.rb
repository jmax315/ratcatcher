require File.expand_path(File.dirname(__FILE__)) + '/var_ref_store'

class IasgnStore < VarRefStore
  def store_type
    :iasgn
  end
end
