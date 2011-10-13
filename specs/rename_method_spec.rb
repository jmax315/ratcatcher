cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'
require cur_dir + '/../app/tree_like_matcher'


describe 'when a method is defined' do
  before :each do
    @tree= RatCatcherStore.parse 'def a_method(arg= something); different_method(0); end'
  end

  it 'should rename a_method if asked to' do
    pending
    @tree.refactor(:rename_method, 'a_method', 'a_new_method')
    @tree.sexp.should be_a_tree_like(s(:defn, :a_new_method, :_, :_))
  end

  it 'should not rename a_method if asked to rename a_different_method' do
    pending
    @tree.refactor(:rename_method, 'a_different_method', 'a_new_method')
    @tree.sexp.should be_a_tree_like(s(:defn, :a_method, :_, :_))
  end

  it 'should rename a method call in an argument default value' do
    pending
    @tree.refactor(:rename_method, 'something', 'nothing')
    @tree.source.should be_code_like "def a_method(arg = nothing)\n  different_method(0)\nend"
  end

  it 'should rename a method call in the method body' do
    pending
    @tree.refactor(:rename_method, 'different_method', 'the_larch')
    @tree.source.should be_code_like "def a_method(arg = something)\n  the_larch(0)\nend"
  end
end

describe 'when a method is called' do
  before :each do
    @tree= RatCatcherStore.parse 'a_method("foo")'
  end

  it 'should rename a_method if asked to' do
    pending
    @tree.refactor(:rename_method, 'a_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:call, :_, :a_new_name, :_))
  end

  it 'should not rename a_method if asked to rename a_different_method' do
    pending
    @tree.refactor(:rename_method, 'a_different_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:call, :_, :a_method, :_))
  end
end

describe 'when a method is called with a block' do
  before :each do
    @tree= RatCatcherStore.parse 'a_method("foo") { puts "got here" }'
  end

  it 'should rename a_method if asked to' do
    pending
    @tree.refactor(:rename_method, 'a_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:iter, s(:call, :_, :a_new_name, :_), :_, :_))
  end

  it 'should not rename a_method if asked to rename a_different_method' do
    pending
    @tree.refactor(:rename_method, 'a_different_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:iter, s(:call, :_, :a_method, :_), :_, :_))
  end
end

describe 'when a method is called inside another method call' do
  before :each do
    @tree= RatCatcherStore.parse 'a_method(a_method("foo"))'
  end

  it 'should rename a_method if asked to' do
    pending
    @tree.refactor(:rename_method, 'a_method', 'a_new_name')
    @tree.sexp.should be_a_tree_like(s(:call, :_, :a_new_name, s(:arglist, s(:call, :_, :a_new_name, :_))))
  end
end

describe 'when a method, b, is called like a.b.c' do
  before :each do
    @tree= RatCatcherStore.parse 'a.b.c'
  end

  it 'should rename a_method if asked to' do
    pending
    @tree.refactor(:rename_method, 'b', 'newbie')
    @tree.source.should be_code_like 'a.newbie.c'
  end

  it 'should rename a_method if asked to' do
    pending
    @tree.refactor(:rename_method, 'a', 'newbie')
    @tree.source.should be_code_like 'newbie.b.c'
  end

  it 'should rename a_method if asked to' do
    pending
    @tree.refactor(:rename_method, 'c', 'newbie')
    @tree.source.should be_code_like 'a.b.newbie'
  end
end
