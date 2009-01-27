class PrettyPrinter
  def print sexp
    "s(:lit, #{sexp.value})"
  end
end


