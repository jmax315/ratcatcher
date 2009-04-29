require 'gtk2'


class RatCatcherStoreGtkWrapper < Gtk::TreeStore
  attr_accessor :rat_catcher_store

  def initialize store
    super(String, Object)
    @rat_catcher_store= store
    store.add_listener(self)
    update store, nil
  end

  def update store, parent
    iter= append parent
    iter[0]= store.text
    iter[1]= store
    store.children.each do |child|
      update child, iter
    end
  end

  def store_changed(updated_node)
    get_iter("0")[0]= updated_node.text
    get_iter("0")[1]= updated_node
  end

end
