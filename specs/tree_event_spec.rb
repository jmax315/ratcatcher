require 'app/ratcatcher_app'


describe RatcatcherApp do
  it "should connect the TreeView's button_press_event to the specified event handler" do
    the_app= RatcatcherApp.new

    the_view= mock(Gtk::TreeView)
    the_view.should_receive(:signal_connect).with("button_press_event")

    the_app.tree_view= the_view
  end
end

