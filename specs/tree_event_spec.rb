require 'app/ratcatcher_app'


describe RatcatcherApp do
  it "should connect the TreeView's button_press_event to the specified event handler" do
    the_app= RatcatcherApp.new

    the_view= mock(Gtk::TreeView)
    the_view.should_receive(:signal_connect).with("button_press_event")

    the_app.tree_view= the_view
  end

  it "should have a popup_context_menu method which pops up a Gtk::Menu on right_click events" do
    mock_context_menu= mock(Gtk::Menu)
    mock_context_menu.should_receive(:popup).with(nil, nil, 3, 31416)

    the_app= RatcatcherApp.new
    the_app.context_menu= mock_context_menu

    right_click_event= Gdk::EventButton.new(Gdk::Event::BUTTON_PRESS)
    right_click_event.button= 3
    right_click_event.time= 31416
    the_app.popup_context_menu(the_app.tree_view, right_click_event)
  end

end

