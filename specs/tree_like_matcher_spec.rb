require 'ruby_parser'
require 'specs/tree_like_matcher'

describe 'tree_like_matcher' do
  it 'should match two equal sexp' do
    target = s(:lasgn, :a_variable, :another_var)
    target.should be_a_tree_like(s(:lasgn, :a_variable, :another_var))
  end

  it 'should match two sexp with wildcard' do
    target = s(:lasgn, :a_variable, :another_var)
    target.should be_a_tree_like(s(:lasgn, :a_variable, :_))
  end

  it 'should not match two sexp without wildcard' do
    target = s(:lasgn, :a_variable, :another_var)
    target.should_not be_a_tree_like(s(:lasgn, :a_variable))
  end
end

