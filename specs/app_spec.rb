require 'app/ratcatcher_app'

describe 'ratcatcher application controller' do

  before :each do
    @the_app= RatcatcherApp.new
  end

  it "should have a Gtk::TreeView" do
    @the_app.tree_view.should be_kind_of(Gtk::TreeView)
  end

  it "should have an invisible Gtk::TreeView" do
    @the_app.tree_view.should_not be_visible
  end

  it "should have a RatCatcherStore" do
    @the_app.store.should be_kind_of(RatCatcherStore)
  end

  it "should have the RatCatcherStore connected to the TreeView" do
    @the_app.tree_view.model.should == @the_app.store
  end

end

describe "loading a file" do
  before :each do
    @filename= 'test_source.rb'
    @source= "1+2"
    file= File.new(@filename, 'w')
    file << @source
    file.close

    @app= RatcatcherApp.new
    @app.args([@filename])
  end

  after :each do
    File.unlink(@filename)
  end

  it "should load the file specified on the command line" do
    @app.store.should == RatCatcherStore.new(@source)
  end
end
