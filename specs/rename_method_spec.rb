cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'
require cur_dir + '/../app/tree_like_matcher'


describe 'when a method is defined' do
  before :each do
    @tree= RatCatcherStore.parse 'def a_method; end'
  end

  it 'should rename a_method if asked to' do
    @tree.apply(:rename_method, 'a_method', 'a_new_method')
    @tree.sexp.should be_a_tree_like(s(:defn, :a_new_method, :_, :_))
  end

  it 'should not rename a_method if asked to rename a_different_method' do
    @tree.apply(:rename_method, 'a_different_method', 'a_new_method')
    @tree.sexp.should be_a_tree_like(s(:defn, :a_method, :_, :_))
  end
end

describe 'when a method is called' do
  before :each do
    @tree= RatCatcherStore.parse 'a_method("foo")'
  end

  it 'should rename a_method if asked to' do
    @tree.apply(:rename_method, 'a_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:call, :_, :a_new_name, :_))
  end

  it 'should not rename a_method if asked to rename a_different_method' do
    @tree.apply(:rename_method, 'a_different_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:call, :_, :a_method, :_))
  end
end

describe 'when a method is called with a block' do
  before :each do
    @tree= RatCatcherStore.parse 'a_method("foo") { puts "got here" }'
  end

  it 'should rename a_method if asked to' do
    @tree.apply(:rename_method, 'a_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:iter, s(:call, :_, :a_new_name, :_), :_, :_))
  end

  it 'should not rename a_method if asked to rename a_different_method' do
    @tree.apply(:rename_method, 'a_different_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:iter, s(:call, :_, :a_method, :_), :_, :_))
  end
end

