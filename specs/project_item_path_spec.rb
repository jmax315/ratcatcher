current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/rat_catcher_store'
require current_dir + '/../app/store_nodes/project_item_store'


describe "A RatCatcherProjectItem" do
  before :each do
    @item= ProjectItemStore.new('my_item',
                                RatCatcherStore.parse('class Zed; end'))
  end

  it "should find itself when passed a nil path" do
    @item.find(nil).should == @item
  end

  it "should find itself when passed an empty path" do
    @item.find('').should == @item
  end

  it "should find itself when passed the path '.'" do
    @item.find('.').should == @item
  end

  it "should return nil when passed an incorrect path" do
    @item.find('foo').should be_nil
  end
end 
