class FindProcessor < SexpProcessor
  attr_reader :results

  def initialize(path)
    super()
    default_method= :deep_copy
  end

  def deep_copy(sexp)
    new_sexp= s()
    while !sexp.empty?
      new_sexp << sexp.shift
    end
    new_sexp
  end
end
