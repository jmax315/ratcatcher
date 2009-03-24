require 'app/ratcatcher_app'


class Gtk::Menu
  def item_text(index)
    children[index].children[0].text
  end
end


describe RatcatcherApp do
  before :each do
    @the_app= RatcatcherApp.new
  end

  it "should have a context menu containing one entry: rename method" do
    @the_app.context_menu.item_text(0).should == "Rename Method"
  end

  it "should call the popup_context_menu on mouse button clicks" do
    mock_widget= "mock widget"
    mock_event= "mock event"
    mock_tree_view= mock(Gtk::TreeView)

    mock_tree_view.
      should_receive(:signal_connect).
      with("button_press_event").
      and_yield(mock_widget, mock_event)

    @the_app.should_receive(:popup_context_menu).with(mock_widget, mock_event)

    @the_app.tree_view= mock_tree_view
  end

  def check_click_response(button, time)
    mock_context_menu= mock(Gtk::Menu)
    yield mock_context_menu

    @the_app.context_menu= mock_context_menu

    right_click_event= Gdk::EventButton.new(Gdk::Event::BUTTON_PRESS)
    right_click_event.button= button
    right_click_event.time= time
    @the_app.popup_context_menu(@the_app.tree_view, right_click_event)
  end

  it "should pop up the context on right_click events" do
    check_click_response(3, 31416) do |mock_context_menu|
      mock_context_menu.should_receive(:popup).with(nil, nil, 3, 31416)
    end
  end

  it "should not pop up the context on left_click events" do
    check_click_response(1, 9999) do |mock_context_menu|
      mock_context_menu.should_not_receive(:popup)
    end
  end

end

