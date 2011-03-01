base_directory= File.expand_path(File.dirname(__FILE__))
require base_directory + '/rat_catcher_store'

class RatCatcherProject
  def initialize
    @items= {}
  end

  def refactor(name, *args)
    @items.values.each {|item| item.refactor(name, *args)}
  end

  def size
    @items.size
  end

  def []= (key, value)
    @items[key]= ProjectItemStore.new(key,
                                      RatCatcherStore.parse(value))
  end

  def [] (key)
    @items[key].source
  end
end
