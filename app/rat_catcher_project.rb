class RatCatcherProject
  def initialize
    @chunks= {}
  end

  def apply(visitor)
    @chunks.each {|key, value| visitor.apply(key, value)}
  end

  def []= (key, value)
    @chunks[key]= value
  end
end
