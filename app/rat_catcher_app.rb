require File.expand_path(File.dirname(__FILE__)) + '/rat_catcher_store.rb'


class RatCatcherApp

  attr_accessor :data_file_name,
                :store

  def initialize
    @store= nil
  end

  def replace_node(path, new_text)
    @store= @store.replace_node(path, new_text)
  end

end
