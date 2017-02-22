class CodeLikeMatcher
  def initialize(expected)
    @expected = expected
  end

  def normalize(code)
    code
  end

  def match_helper(expected, target)
    normalize(expected) == normalize(target)
  end

  def matches?(target)
    @target= target
    match_helper(@expected, target)
  end

  def failure_message
    "expected #{@target.inspect} to be code like #{@expected.inspect}"
  end

  def failure_message_when_negated
    "expected #{@target.inspect} not to be code like #{@expected.inspect}"
  end
end


def be_code_like(expected)
  CodeLikeMatcher.new(expected)
end
