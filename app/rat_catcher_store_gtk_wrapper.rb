require 'gtk2'


class RatCatcherStoreGtkWrapper < Gtk::TreeStore
  attr_accessor :rat_catcher_store

  def initialize(store)
    super(String, Object)
    @rat_catcher_store= store
    store.add_listener(self)
    update store, nil
  end

  def update(store, parent)
    iter= append(parent)
    iter[0]= store.text
    iter[1]= store
    store.add_listener(self)
    store.children.each do |child|
      update(child, iter)
    end
  end

  def store_changed(new_store)
    update_node(new_store, get_iter("0"))
  end

  def update_node(new_store, iter)
    if iter == nil
      return false
    end

    if new_store.object_id == iter[1].object_id
      iter[0]= new_store.text

#       child= iter.first_child
#       while child.remove do
#       end

      new_store.children.each do |child_store|
        update(child_store, iter)
      end
      return true
    end

    child= iter.first_child
    begin
      if child == nil
        return false
      end

      if update_node(new_store, child)
        return true
      end
    end while child.next!

    return false
  end

end
