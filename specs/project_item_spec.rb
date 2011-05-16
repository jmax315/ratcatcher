current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/rat_catcher_store'


describe "A RatCatcherProjectItemStore" do
  before :each do
    @store= RatCatcherStore.parse 'a_var= 4'
    @project_item= ProjectItemStore.new("J. Project Item Store", @store)
  end

  it "should return the underlying store's sexp" do
    @project_item.sexp.should == @store.sexp
  end
end
