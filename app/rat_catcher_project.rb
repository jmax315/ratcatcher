base_directory= File.expand_path(File.dirname(__FILE__))
require base_directory + '/rat_catcher_project_item'

class RatCatcherProject
  def initialize
    @items= []
  end

  def apply(visitor)
    @items.each {|i| visitor.apply(i)}
  end

  def []= (key, value)
    @items << RatCatcherProjectItem.new(key, value)
  end
end
