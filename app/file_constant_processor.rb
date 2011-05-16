require 'sexp_processor'

class FILEConstantProcessor < SexpProcessor
  def initialize(item_name)
    super()
    @item_name= item_name
  end

  def process_str(sexp)
    sexp.shift
    old_string= sexp.shift
    (old_string == @item_name)? s(:const, :__FILE__): s(:str, old_string)
  end
end

