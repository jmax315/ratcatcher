require 'ruby_parser'
require 'ruby2ruby'



class RatCatcherStore
  attr_accessor :children
  attr_reader :text

  def self.parse source_code
    RatCatcherStore.from_sexp(RubyParser.new.process(source_code))
    rescue ParseError
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
    if !File.exists?(file_name_for_class(name))
      raise NameError, "Can't find file to load for: #{name}"
    end
    
    load(file_name_for_class(name))
    const_get(name)
  end

  def self.file_name_for_class(class_name)
    app_directory= File.dirname(__FILE__)
    subclass_subdir= "store_nodes"
    
    "#{app_directory}/#{subclass_subdir}/#{un_camel_case(class_name.to_s)}.rb"
  end

  def self.class_for_sexp_type(sexp_type)
    const_get("#{camel_case(sexp_type.to_s)}Store")
  end

  def self.class_for_file_name(file_name)
    const_get(camel_case(File.basename(file_name, ".rb")))
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
  end

  def sexplist_from_children
    @children.map {|child| child.sexp}
  end

  def children_from_subexpressions(subexpressions)
    @children= subexpressions.map { | child | RatCatcherStore.from_sexp(child) }
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

  def find(path)
    if !path || path == ""
      return self
    end
    
    first_path_element, rest_of_path = path.split("/", 2)

    if first_path_element == "."
      return find(rest_of_path)
    end

    find_child_match(first_path_element, rest_of_path)
  end

  def find_child_match(first_path_element, rest_of_path)
    @children.each do |kid|
      kid_match= kid.matches(first_path_element, rest_of_path)
      return kid_match if kid_match
    end
    nil
  end

  def matches(first_path_element, rest_of_path)
    if respond_to?(:name)
      if first_path_element != name
        nil
      elsif rest_of_path
        find(rest_of_path)
      else
        self
      end
    else
      find_child_match(first_path_element, rest_of_path)
    end
  end

  def path_reference(path)
    path.inject(self) do |value, index|
      value= value[index]
    end
  end
  
  def apply(refactoring, *args)
    if (respond_to?(refactoring))
      send(refactoring, *args)
    end
    children.each { |child| child.apply(refactoring, *args) }
  end
end
