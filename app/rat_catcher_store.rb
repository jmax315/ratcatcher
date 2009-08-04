require 'ruby_parser'
require 'ruby2ruby'



class RatCatcherStore
  attr_accessor :children
  attr_reader :text

  def self.parse source_code
    RatCatcherStore.from_sexp(RubyParser.new.process(source_code))
  end

  def self.camel_case(s)
    s.split(/_/).map {|component| component.capitalize}.join('')
  end

  def self.un_camel_case(s)
    rv= s.gsub(/[A-Z]/, '_\0')
    rv= rv.gsub(/^_/, '')
    rv.downcase
  end

  def self.const_missing(name)
    app_directory= File.dirname(__FILE__)
    subclass_subdir= "store_nodes"
    file_name= "#{app_directory}/#{subclass_subdir}/#{un_camel_case(name.to_s)}.rb"
    
    if !File.exists?(file_name)
      raise NameError, "Can't find file to load for: #{name}"
    end
    
    load(file_name)
    const_get(name)
  end

  def self.class_for_sexp_type(sexp_type)
    const_get("#{camel_case(sexp_type.to_s)}Store")
  end

  def self.from_sexp new_sexp
    if new_sexp == nil
      return NilStore.new(nil)
    end
    
    subclass= class_for_sexp_type(new_sexp[0])
    subclass.new(new_sexp)
  end

  private
  
  def initialize new_sexp
    @children= []
    @text= ''
    @sexp= new_sexp
  end

  def sexplist_from_children
    @children[0..-1].map {|child| child.sexp}
  end

  public

  def replace_node(path, new_text)
    if path.size == 0
      RatCatcherStore.from_sexp(s(:call, sexp[1], new_text.to_sym, sexp[3]))
    else
      @children[path[0]]= @children[path[0]].replace_node(path[1..-1], new_text)
      self
    end
  end

  def sexp
      @sexp
  end

  def ==(right)
    sexp == right.sexp
  end

  def to_ruby
    Ruby2Ruby.new.process(sexp)
  end

  def size
    @children.size
  end

  def [](index)
    @children[index]
  end

  def path_reference(path)
    path.inject(self) do |value, index|
      value= value[index]
    end
  end

  def apply(refactoring)
    refactoring.apply(self)
  end
end
