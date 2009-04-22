require 'app/rat_catcher_app'


class Gtk::Menu
  def item_label(index)
    children[index].children[0]
  end

  def item_text(index)
    item_label(index).text
  end
end


describe RatCatcherApp do
  before :each do
    @the_app= RatCatcherApp.new
  end

  it "has a context menu containing one entry: rename method" do
    @the_app.context_menu.children[0].should be_visible
    @the_app.context_menu.item_text(0).should == "Rename Method"
  end

  it "calls the app's rename_method_menu_callback method when 'rename method' is activated" do
    @the_app.should_receive(:rename_method_menu_callback)
    @the_app.context_menu.children[0].activate
  end

  it "has a visible context menu" do
    @the_app.context_menu.should be_visible
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

    @the_app.connect_popup_signal(mock_tree_view)
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
      @the_app.tree_view.should_receive(:get_path_at_pos).and_return("0")
      mock_context_menu.should_receive(:popup).with(nil, nil, 3, 31416)
    end
  end

  it "should not pop up the context on left_click events" do
    check_click_response(1, 9999) do |mock_context_menu|
      mock_context_menu.should_not_receive(:popup)
    end
  end
  
  def should_return_array(object, *selectors)
    return object if selectors.size <= 0

    new_mock= mock(selectors[0].to_s)
    object.should_receive(selectors[0]).and_return([new_mock])
    should_return_array(new_mock, *selectors[1..-1])
  end

  it "should connect the tree's renderer's 'edited' signal to the app's rename_method method" do
    mock_tree_view= mock(Gtk::TreeView)
    mock_renderer= should_return_array(mock_tree_view, :columns, :cell_renderers)

    mock_renderer.
      should_receive(:signal_connect).
      with("edited")

    @the_app.connect_edit_signal(mock_tree_view)
  end

end

