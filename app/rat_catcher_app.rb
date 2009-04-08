require 'gtk2'
require 'app/rat_catcher_store.rb'
require 'ruby2ruby'

class RatCatcherApp

  attr_accessor :main_window,
                :context_menu,
                :current_node,
                :tree_view,
                :file_name

  def initialize
    @tree_view= initialize_tree_view
    @context_menu= initialize_context_menu
    @main_window= initialize_main_window(tree_view)
  end

  def initialize_main_window(tree_view)
    new_main_window= Gtk::Window.new
    new_main_window.add(tree_view)
    new_main_window.show
    new_main_window
  end

  def initialize_tree_view
    new_tree_view= Gtk::TreeView.new
    renderer= Gtk::CellRendererText.new
    renderer.editable= true
    new_tree_view.append_column(Gtk::TreeViewColumn.new("",
                                                        renderer,
                                                        :text => 0))
    new_tree_view.model= RatCatcherStore.new
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
    a_tree_view.columns[0].cell_renderers[0].signal_connect("edited") do |renderer, path, new_text|
      rename_method(renderer, path, new_text)
    end
  end

  def rename_method(renderer, path, new_text)
    store.set_text(path, new_text)
    old_sexp= store.sexp(path)
    new_sexp= s(:call, old_sexp[1], new_text.to_sym, old_sexp[3])
    store.set_sexp(path, new_sexp)
  end

  def initialize_context_menu
    new_context_menu= Gtk::Menu.new
    
    rename_method_item= Gtk::MenuItem.new("Rename Method")
    rename_method_item.signal_connect("activate") do |w|
      rename_method_menu_callback
    end
    
    new_context_menu.append rename_method_item
    new_context_menu.show # This is here only to make specs pass; there
                          # appears to be a bug in Ruby::Gnome2 such that
                          # visible? lies if we just do a show_all. Grrr.
    new_context_menu.show_all
    new_context_menu
  end

  def load(file_name)
    File.new(file_name).gets(nil)
  end

  def args(argv)
    @data_file= argv[0]
    tree_view.model= RatCatcherStore.new(load(@data_file))
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

  def store
    tree_view.model
  end

  def store=(new_tree_store)
    tree_view.model= new_tree_store
  end

  def save
    File.open(@file_name, 'w') do | f |
      f.write(Ruby2Ruby.new.process(store.sexp("0")))
    end
  end

  def rename_method_menu_callback
    
  end
end
