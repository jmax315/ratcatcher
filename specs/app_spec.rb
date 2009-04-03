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

  it "should have a main window" do
    @the_app.main_window.should be_kind_of(Gtk::Window)
  end

  it "should have the TreeView inside the main window" do
    @the_app.tree_view.should be_ancestor(@the_app.main_window)
  end

  it "should have a RatCatcherStore" do
    @the_app.store.should be_kind_of(RatCatcherStore)
  end

  it "should have the RatCatcherStore connected to the TreeView" do
    @the_app.tree_view.model.should == @the_app.store
  end

  it "should have a single Gtk::CellRendererText" do
    @the_app.tree_view.columns[0].cell_renderers[0].should be_kind_of(Gtk::CellRendererText)
  end

  it "should have an editable renderer" do
    @the_app.tree_view.columns[0].cell_renderers[0].should be_editable
  end

  it "should have one column in the TreeView" do
    @the_app.tree_view.columns.should have(1).column
  end

  it "should have the right sort of column" do
    @the_app.tree_view.columns[0].should be_kind_of(Gtk::TreeViewColumn)
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

  it "should show the Gtk::TreeView after loading the file" do
    @app.tree_view.should be_visible
  end

  it "should show the main window after loading the file" do
    @app.main_window.should be_visible
  end

end


describe "initializing the tree view" do
  before :each do
    @app= RatcatcherApp.new
  end

  it "should connect the popup menu" do
    @app.should_receive(:connect_popup_signal)

    @app.initialize_tree_view(nil)
  end

  it "should connect the edit signal" do
    @app.should_receive(:connect_edit_signal)

    @app.initialize_tree_view(nil)
  end
end


describe "calling the rename_method method" do
  it "it should change the text of the tree node" do
    @app= RatcatcherApp.new
    @store= RatCatcherStore.new '1+1'
    @app.store= @store
    @path= "0:0"
    @new_text= "ferd"
    @app.rename_method("junk_renderer", @path, @new_text)

    @store.text(@path).should == @new_text
  end
end
