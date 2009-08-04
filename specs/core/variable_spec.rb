require 'app/rat_catcher_store'
require 'app/refactorings/variable_rename'
require 'specs/tree_like_matcher'

describe 'variable assignment parse tree' do
  def variable_should_be(name)
    @tree.sexp.should be_a_tree_like(s(:lasgn, name.to_sym, :_))
    @tree.to_ruby.should == "#{name} = 5"
  end

  before :each do
    @tree= RatCatcherStore.parse 'a_variable = 5'
  end

  it 'should contain a tree with the variable assignment' do
    @tree.sexp.should be_a_tree_like(s(:lasgn, :a_variable, :_))
  end

  it 'should regenerate the source code' do
    @tree.to_ruby.should == 'a_variable = 5'
  end

  it 'should rename a_variable' do
    @tree.apply(VariableRename.new('a_variable', 'new_name'))
    variable_should_be('new_name')
  end

  it 'should not rename the_wrong_variable' do
    @tree.apply(VariableRename.new('the_wrong_variable', 'new_name'))
    variable_should_be('a_variable')
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
    @tree.to_ruby.should == 'a_var, b_var = 1, 2'
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
    @tree.to_ruby.should == 'a_var, b_var = [1, 2]'
  end
end
