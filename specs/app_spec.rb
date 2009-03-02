require 'app/ratcatcher_app'

describe 'ratcatcher application controller' do

  it "should have a visible Gtk::TreeView" do
    the_app= RatcatcherApp.new
    the_app.tree_view.should be_kind_of(Gtk::TreeView)
  end

end
