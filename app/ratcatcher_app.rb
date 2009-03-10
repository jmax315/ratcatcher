require 'gtk2'
require 'app/rat_catcher_store.rb'

class RatcatcherApp

  attr_accessor :tree_view, :store, :main_window, :cell_renderer, :column

  def initialize
    @tree_view= Gtk::TreeView.new

    @cell_renderer= Gtk::CellRendererText.new

    @column= Gtk::TreeViewColumn.new "", cell_renderer, :text => 0

    tree_view.append_column(column)

    @store= RatCatcherStore.new

    tree_view.model= store

    @main_window= Gtk::Window.new
    main_window.add(tree_view)
    main_window.show
  end

  def args(argv)
    store= RatCatcherStore.new(File.new(argv[0]).gets(nil))
    tree_view.model= store
    tree_view.show
  end

  def run
    main_window.signal_connect("destroy") { Gtk.main_quit }
    Gtk.main
  end

end
