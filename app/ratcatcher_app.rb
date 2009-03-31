require 'gtk2'
require 'app/rat_catcher_store.rb'

class RatcatcherApp

  attr_accessor :store,
                :main_window,
                :context_menu,
                :current_node,
                :tree_view

  def initialize
    @store= RatCatcherStore.new
    @tree_view= initialize_tree_view(store)
    @context_menu= initialize_context_menu
    @main_window= initialize_main_window(tree_view)
  end

  def initialize_main_window(tree_view)
    new_main_window= Gtk::Window.new
    new_main_window.add(tree_view)
    new_main_window.show
    new_main_window
  end

  def initialize_tree_view(store)
    new_tree_view= Gtk::TreeView.new
    renderer= Gtk::CellRendererText.new
    renderer.editable= true
    new_tree_view.append_column(Gtk::TreeViewColumn.new("",
                                                        renderer,
                                                        :text => 0))
    new_tree_view.model= store

    connect_popup_signal(new_tree_view)
    connect_edit_signal(new_tree_view)

    new_tree_view
  end

  def connect_popup_signal(a_tree_view)
    a_tree_view.signal_connect("button_press_event") do |widget, event|
      popup_context_menu(widget, event)
    end
  end

  def connect_edit_signal(a_tree_view)
    a_tree_view.columns[0].cell_renderers[0].signal_connect("edited") do |path, new_text|
#      modify_node(path, new_text)
    end
  end

  def initialize_context_menu
    new_context_menu= Gtk::Menu.new
    
    rename_method_item= Gtk::MenuItem.new("Rename Method")
    rename_method_item.signal_connect("activate") {|w| rename_method }
    
    new_context_menu.append rename_method_item
    new_context_menu.show # This is here only to make specs pass; there
                          # appears to be a bug in Ruby::Gnome2 such that
                          # visible? lies if we just do a show_all. Grrr.
    new_context_menu.show_all
    new_context_menu
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

  def rename_method
    
  end
end
