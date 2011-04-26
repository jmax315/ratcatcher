base_directory= File.expand_path(File.dirname(__FILE__))
require base_directory + '/rat_catcher_store'

class RatCatcherProject
  def initialize
    @items= {}
  end

  def refactor(name, *args)
    if (name == :rename_item)
      old_name= args[0]
      new_name= args[1]
      if @items[old_name]
        @items[new_name]= @items[old_name]
        @items.delete(old_name)
      end
    end
    @items.each do |key, item|
      if name == :rename_item
        new_args= args + [key]
      else
        new_args= args
      end
      item.refactor(name, *new_args)
    end
  end

  def size
    @items.size
  end

  def []= (key, value)
    @items[key]= ProjectItemStore.new(key,
                                      RatCatcherStore.parse(value, key))
  end

  def [] (key)
    @items[key].source
  end
end
