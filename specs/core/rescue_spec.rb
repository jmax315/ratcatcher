current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'

describe 'A begin/end block with a rescue clause' do
  before :each do
    src= %q{
      begin
        4
      rescue
        5
      end
    }

    @store= RatCatcherStore.parse(src)
  end

  it 'should have two children' do
    @store.children.size.should == 2
  end

  it 'should have the block body as its first child' do
    @store.children[0].sexp.should == s(:lit, 4)
  end

  it 'should have the rescue clause as its second child' do
    @store.children[1].sexp.should == s(:resbody, s(:array), s(:lit, 5))
  end
end
