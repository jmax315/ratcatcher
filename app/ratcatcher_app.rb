require 'gtk2'
require 'app/rat_catcher_store.rb'

class RatcatcherApp

  attr_accessor :store,
                :main_window,
                :context_menu,
                :current_node
  attr_reader   :tree_view

  def initialize
    @store= RatCatcherStore.new

    initialize_tree_view(store)
    initialize_context_menu

    @main_window= Gtk::Window.new
    main_window.add(tree_view)
    main_window.show
  end

  def initialize_tree_view(store)
    self.tree_view= Gtk::TreeView.new
    tree_view.append_column(Gtk::TreeViewColumn.new("",
                                                    Gtk::CellRendererText.new,
                                                    :text => 0))
    tree_view.model= store
  end

  def initialize_context_menu
    self.context_menu= Gtk::Menu.new
    
    rename_method_item= Gtk::MenuItem.new("Rename Method")
    rename_method_item.signal_connect("activate") {|w| rename_method }
    
    context_menu.append rename_method_item
    context_menu.show # This is here only to make specs pass; there
    # appears to be a bug in Ruby::Gnome2 such that
    # visible? lies if we just do a show_all. Grrr.
    context_menu.show_all
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

  def popup_context_menu(widget, event)
    if event.kind_of? Gdk::EventButton and event.button == 3
      self.current_node= tree_view.get_path_at_pos(event.x, event.y)
      context_menu.popup(nil, nil, event.button, event.time)
    end
  end

  def tree_view=(new_value)
    @tree_view= new_value
    tree_view.signal_connect("button_press_event") do |widget, event|
      popup_context_menu(widget, event)
    end
  end

  def rename_method
  end
end
