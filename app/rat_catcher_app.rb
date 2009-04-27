require 'gtk2'
require 'app/rat_catcher_store.rb'
require 'app/rat_catcher_store_gtk_wrapper.rb'

class RatCatcherApp

  attr_accessor :main_window,
                :context_menu,
                :current_node,
                :tree_view,
                :data_file_name,
                :save_button,
                :store

  def initialize
    @tree_view= initialize_tree_view
    @context_menu= initialize_context_menu
    @button_bar= initialize_button_bar
    @main_window= initialize_main_window
    connect_signals
  end

  def initialize_button_bar
    button_box= Gtk::HButtonBox.new

    @save_button= Gtk::Button.new("Save")
    button_box.pack_start(@save_button)
    button_box.show_all
    button_box.show
    button_box
  end


  def connect_signals
    connect_popup_signal(@tree_view)
    connect_edit_signal(@tree_view)
    connect_clicked_signal(@save_button, method(:save))
  end

  def connect_clicked_signal(button, m)
    button.signal_connect("clicked") do |widget|
      m.call
    end
  end


  def initialize_main_window
    new_main_window= Gtk::Window.new
    top_box= Gtk::VBox.new
    new_main_window.add(top_box)
    top_box.show

    top_box.pack_start(@button_bar)
    top_box.pack_start(@tree_view)

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
    @store= RatCatcherStore.parse
    new_tree_view.model= RatCatcherStoreGtkWrapper.new(@store)

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
    node= store.path_reference(path)
    node.sexp[2]= new_text.to_sym
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
    sourcefile = File.new(file_name)
    sourcecode = sourcefile.gets(nil)
    sourcefile.close
    sourcecode
  end

  def args(argv)
    @data_file_name= argv[0]
    @store= RatCatcherStore.parse(load(@data_file_name))
    tree_view.model= RatCatcherStoreGtkWrapper.new(@store)
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

  def save
    File.open(@data_file_name, 'w') do | f |
      f.write(store.to_s)
    end
  end

  def rename_method_menu_callback
    
  end
end
