base_directory= File.expand_path(File.dirname(__FILE__))
require base_directory + '/rat_catcher_store'

class RatCatcherProjectItem
  attr_accessor :code

  def initialize(code)
    @code= RatCatcherStore.parse(code)
  end

  def apply(refactoring, *args)
    @code.apply(refactoring, *args)
  end

  def to_ruby
    @code.to_ruby
  end
end
