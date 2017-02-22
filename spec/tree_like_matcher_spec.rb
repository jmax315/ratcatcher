require_relative '../app/tree_like_matcher'

describe 'tree_like_matcher' do
  it 'should match two equal sexp' do
    pending
    target = s(:lasgn, :a_variable, :another_var)
    target.should be_a_tree_like(s(:lasgn, :a_variable, :another_var))
  end

  it 'should match two sexp with wildcard' do
    pending
    target = s(:lasgn, :a_variable, :another_var)
    target.should be_a_tree_like(s(:lasgn, :a_variable, :_))
  end

  it 'should not match two sexp without wildcard' do
    pending
    target = s(:lasgn, :a_variable, :another_var)
    target.should_not be_a_tree_like(s(:lasgn, :a_variable))
  end

  it 'should match with a wildcard in the node type' do
    pending
    target = s(:lasgn, :a_variable, :another_var)
    target.should_be_a_tree_like(s(:_, :a_variable, :another_var))
  end

  it 'should match two sexp with a repeated wildcard' do
    pending
    target = s(:lasgn, :a_variable, :another_var)
    target.should be_a_tree_like(s(:lasgn, :*))
  end

  it 'should not match a :* wildcard that is not at the end' do
    pending
    target = s(:lasgn, :a, :b, :c)
    target.should_not be_a_tree_like(s(:lasgn, :*, :c))
  end
end

