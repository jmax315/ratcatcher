require 'app/rat_catcher_app'
require 'ftools'

describe 'ratcatcher application controller' do

  before :each do
    @the_app= RatCatcherApp.new
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

  it "should have a Save button" do
    @the_app.save_button.should be_kind_of(Gtk::Button)
  end

  it "should have the Save button inside the main window" do
    @the_app.save_button.should be_ancestor(@the_app.main_window)
  end

  it "should have a Save button with the lable 'Save'" do
    @the_app.save_button.label.should == "Save"
  end

  it "should have a RatCatcherStore" do
    @the_app.store.should be_kind_of(RatCatcherStore)
  end

  it "should have the RatCatcherStore connected to the TreeView" do
    @the_app.tree_view.model.should == @the_app.store.model
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

    @app= RatCatcherApp.new
    @app.args([@filename])
  end

  after :each do
    File.unlink(@filename)
  end

  it "should load the file specified on the command line" do
    @app.store.should == RatCatcherStore.parse(@source)
  end

  it "should show the Gtk::TreeView after loading the file" do
    @app.tree_view.should be_visible
  end

  it "should show the main window after loading the file" do
    @app.main_window.should be_visible
  end

  it "should assign the new RatCatcherStore to both the app and the TreeView" do
    @app.store.model.should == @app.tree_view.model
  end

end


describe "initializing the button bar" do
  it "should connect the save button" do
    @app= RatCatcherApp.new
    @app.initialize_button_bar

    @app.should_receive(:connect_clicked_signal).with(@app.save_button, @app.method(:save))

    @app.connect_signals
  end
end


describe "the connect_clicked_signal method" do
  it "should call signal_connect('clicked') on the passed widget" do
    mock_widget= mock("widget")
    mock_widget.should_receive(:signal_connect).with("clicked")

    app= RatCatcherApp.new
    app.connect_clicked_signal(mock_widget, nil)
  end

  it "should invoke the passed proc when the button is clicked" do
    proc_invoked= false
    p= Proc.new do
      proc_invoked= true
    end

    button= Gtk::Button.new

    app= RatCatcherApp.new
    app.connect_clicked_signal(button, p)
    button.clicked

    proc_invoked.should be_true
  end
end

describe "initializing the tree view" do
  before :each do
    @app= RatCatcherApp.new
  end

  it "should connect the popup menu" do
    @app.should_receive(:connect_popup_signal)

    @app.initialize_tree_view
    @app.connect_signals
  end

  it "should connect the edit signal" do
    @app.should_receive(:connect_edit_signal)

    @app.initialize_tree_view
    @app.connect_signals
  end
end


describe "calling the rename_method method" do
  before :each do
    @app= RatCatcherApp.new
    @store= RatCatcherStore.parse 'zed'
    @app.store= @store
    @app.tree_view.model= @store.model
    @new_text= "ferd"
    @app.rename_method("junk_renderer", '', @new_text)
  end

  it "it should change the text of the tree node" do
    @store.text.should == @new_text
  end

  it "should change the Sexp of the tree node" do
    @store.sexp.should == s(:call, nil, @new_text.to_sym, s(:arglist))
  end

end


describe "calling the rename_method method for a more complex method call" do
  before :each do
    @app= RatCatcherApp.new
    @store= RatCatcherStore.parse '1+1'
    @app.store= @store
    @app.tree_view.model= @store.model
    @new_text= "-"
    @app.rename_method("junk_renderer", '', @new_text)
  end

  it "should change the Sexp of the tree node" do
    @store.sexp.should == s(:call, s(:lit, 1), @new_text.to_sym, s(:arglist, s(:lit, 1)))
  end

end


describe "calling the rename_method method for a non-root method call" do
  before :each do
    @app= RatCatcherApp.new
    @store= RatCatcherStore.parse '1+2+3'
    @app.store= @store
    @app.tree_view.model= @store.model
    @new_text= "-"
    @app.rename_method("junk_renderer", '0', @new_text)
  end

  it "should change the Sexp of the tree node" do
    @store.sexp.should == s(:call, 
                            s(:call, s(:lit, 1), :-, s(:arglist, s(:lit, 2))),
                            :+,
                            s(:arglist, s(:lit, 3)))
  end

end


describe "calling the save method" do

  before :each do
    @file_name= "test_file.rb"
    File.rm_f(@file_name)

    @app= RatCatcherApp.new
    @app.data_file_name= @file_name
  end

  after :each do
    File.rm_f(@file_name)
  end

  it "should save the correct Ruby code" do
    code= '2+2-1'

    @app.store= RatCatcherStore.parse(code)
    @app.save

    results= File.new(@file_name).read
    results.should == "((2 + 2) - 1)"
  end

  it "should save the other correct Ruby code" do
    code= '2*3-1'

    @app.store= RatCatcherStore.parse(code)
    @app.save

    results= File.new(@file_name).read
    results.should == "((2 * 3) - 1)"
  end

end
