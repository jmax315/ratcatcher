require 'app/rat_catcher_store'
require 'specs/tree_like_matcher'

describe 'variable assignment parse tree' do
  before :each do
    @tree= RatCatcherStore.parse 'a_variable = 5'
  end

  it 'should contain a tree with the variable assignment' do
    @tree.sexp.should be_a_tree_like(s(:lasgn, :a_variable, :_))
  end

  it 'should regenerate the source code' do
    @tree.to_ruby.should == 'a_variable = 5'
  end
end

describe 'simple multiple variable assignment parse tree' do
  before :each do
    @tree= RatCatcherStore.parse 'a_var,b_var = 1,2'
  end
  
  it 'should contain a tree with the variable assignment' do
    @tree.sexp.should be_a_tree_like(s(:masgn, s(:array, s(:lasgn, :a_var), s(:lasgn, :b_var)), s(:array, s(:lit, 1), s(:lit, 2))))
  end  
  
  it 'should regenerate the source code' do
    @tree.to_ruby.should == 'a_var,b_var = 1,2'
  end
end

describe 'multiple variable assignment parse tree' do
  before :each do
    @tree= RatCatcherStore.parse 'a_var,b_var = [1,2]'
  end
  
  it 'should contain a tree with the variable assignment' do
    @tree.sexp.should be_a_tree_like(s(:masgn, s(:array, s(:lasgn, :a_var), s(:lasgn, :b_var)), s(:to_ary, s(:array, s(:lit, 1), s(:lit, 2)))))
  end  
  
  it 'should regenerate the source code' do
    @tree.to_ruby.should == 'a_var,b_var = [1,2]'
  end
end

describe 'variable assignment API' do
  it 'should support renaming a_variable' do
    pending 'until RatCatcherApp is free from GTK'
  end
end

