CurrentDir= File.expand_path(File.dirname(__FILE__)) unless Object.const_defined?(:CurrentDir)

require CurrentDir + '/refactoring_processor'

class Refactoring
  def initialize(name)
    @name= name.to_s
  end

  def self.list
    Dir.glob('app/refactorings/*.rb').map{|s| File.basename(s, '.rb')}
  end

  def create(*args)
    get_refactoring_class.new(*args)
  end

  def class_name
    words= @name.split(/_/)
    words.map! {|s| s.capitalize}
    words.join
  end

  def file_name
    CurrentDir + '/refactorings/' + @name
  end

  def get_refactoring_class
    begin
      require file_name
    rescue LoadError => e
      raise RatCatcherException.new("unknown refactoring: #{@name}")
    end
    Kernel.const_get(class_name)
  end

end
