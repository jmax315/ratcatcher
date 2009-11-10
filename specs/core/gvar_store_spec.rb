cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../../app/rat_catcher_store'


describe 'self references' do
  before :each do
    @tree= RatCatcherStore.parse '$!'
  end

  it 'should contain a tree with the self reference' do
    @tree.sexp.should be_a_tree_like(s(:gvar, :$!))
  end

  it 'should regenerate the source code' do
    @tree.to_ruby.should == '$!'
  end
end
