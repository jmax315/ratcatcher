class TreeLikeMatcher
  def initialize(expected)
    @expected = expected
  end

  def match_helper(expected, target)
    if expected == :_
      true
    elsif !expected.kind_of?(Sexp) || !target.kind_of?(Sexp)
      expected == target
    else
      expected.size == target.size &&
        expected.zip(target).all? { |pair| match_helper(pair[0], pair[1]) }
    end
  end

  def matches?(target)
    @target= target
    match_helper(@expected, target)
  end

  def failure_message
    "expected #{@target.inspect} to be a tree like #{@expected}"
  end

  def negative_failure_message
    "expected #{@target.inspect} not to be in Zone #{@expected}"
  end
end


def be_a_tree_like(expected)
  TreeLikeMatcher.new(expected)
end
