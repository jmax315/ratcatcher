require 'gtk2'
require 'app/rat_catcher_store.rb'

class RatcatcherApp

  def initialize
    @tree_view= Gtk::TreeView.new
    @store= RatCatcherStore.new
    @tree_view.model= @store
  end

  def tree_view
    @tree_view
  end

  def store
    @store
  end

  def args(argv)
    @store= RatCatcherStore.new(File.new(argv[0]).gets(nil))
  end

end
