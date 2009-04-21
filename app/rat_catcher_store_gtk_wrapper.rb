require 'gtk2'


class RatCatcherStoreGtkWrapper < Gtk::TreeStore
  attr_accessor :rat_catcher_store

  def initialize store
    super(String)
    @rat_catcher_store= store
    update store, nil
  end

  def update store, parent
    iter= append parent
    iter[0]= store.text
    store.children.each do |child|
      update child, iter
    end
  end

end
