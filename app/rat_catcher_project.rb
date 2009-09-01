base_directory= File.expand_path(File.dirname(__FILE__))
require base_directory + '/rat_catcher_project_item'

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
    @items[key]= RatCatcherProjectItem.new(value)
  end

  def [] (key)
    @items[key].to_ruby
  end
end
