
CurrentDir= File.expand_path(File.dirname(__FILE__)) unless Object.const_defined?(:CurrentDir)

class Refactoring
  def initialize(name)
    @name= name.to_s
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
    rescue LoadError
      raise "unknown refactoring: #{@name}"
    end
    Kernel.const_get(class_name)
  end

end
