require File.expand_path(File.dirname(__FILE__)) + '/var_ref_store'

class LasgnStore < VarRefStore
  def store_type
    :lasgn
  end
end
