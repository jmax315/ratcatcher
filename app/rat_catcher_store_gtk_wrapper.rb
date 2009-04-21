require 'gtk2'


class RatCatcherStoreGtkWrapper < Gtk::TreeStore
  attr_accessor :rat_catcher_store

  def initialize store
    @rat_catcher_store= store
    super(String)
  end

end
