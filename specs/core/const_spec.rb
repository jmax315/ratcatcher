current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'

describe 'a constant reference' do
  it 'has a node with the correct text' do
    @tree= RatCatcherStore.parse %q{
      Ferd
    }
    @tree.text.should == 'Ferd'
  end
end
