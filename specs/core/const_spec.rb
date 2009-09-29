current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'

describe 'a constant reference' do
  before :each do
    @tree= RatCatcherStore.parse %q{
      Ferd
    }
  end

  it 'has a node with the correct text' do
    @tree.text.should == 'Ferd'
  end

  it 'has a sexp of the correct form' do
    @tree.sexp.should be_a_tree_like(s(:const, :Ferd))
  end

end
