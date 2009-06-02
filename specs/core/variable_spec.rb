require 'app/rat_catcher_store'
require 'specs/tree_like_matcher'

describe 'tree for variable assignment' do
  before :each do
    @tree= RatCatcherStore.parse 'a_variable = 5'
  end

  it 'should contain a tree with the variable assignment' do
    @tree.sexp.should be_a_tree_like(s(:lasgn, :a_variable, :_))
  end

  it 'should regenerate the source code' do
    @tree.text.should == 'a_variable = 5'
  end
end

describe 'app for variable assignment' do
  it 'should be possible to rename a_variable' do
    pending 'until RatCatcherApp is free from GTK'
  end
end

