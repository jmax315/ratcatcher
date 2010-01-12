base_directory= File.expand_path(File.dirname(__FILE__))
require base_directory + '/rat_catcher_store'

class RatCatcherProject
  def initialize
    @items= {}
  end

  def apply(refactoring, *args)
    @items.values.each {|item| item.apply(refactoring, *args)}
  end

  def size
    @items.size
  end

  def []= (key, value)
    @items[key]= ProjectItemStore.new(key,
                                      RatCatcherStore.parse(value))
  end

  def [] (key)
    @items[key].to_ruby
  end

  def find(path)
    first_path_element = path.split("/", 2)[0]
    @items[first_path_element].find(path)
  end
end
