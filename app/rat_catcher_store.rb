require 'gtk2'
require 'ruby_parser'
require 'ruby2ruby'


class RatCatcherStore
  TEXT= 0
  SEXP= 1


  def initialize source_code= ''
    @gtk_store= Gtk::TreeStore.new(String, Object)
    @parse_tree= RubyParser.new.process source_code

    load @parse_tree, nil
  end

  def append parent
    @gtk_store.append parent
  end

  def get_iter path
    @gtk_store.get_iter path
  end

  def model
    @gtk_store
  end

  def new_text
    if @gtk_store.get_iter('0') == nil
      return ""
    end
    @gtk_store.get_iter('0')[TEXT]
  end

  def new_text=(new_value)
    if @gtk_store.get_iter('0') != nil
      @gtk_store.get_iter('0')[TEXT]= new_value
    end
  end

  def new_sexp
    if @gtk_store.get_iter('0') == nil
      return nil
    end
    @gtk_store.get_iter('0')[SEXP]
  end

  def children
    []
  end

  def gtk_tree=(new_value)
    @gtk_tree= new_value
  end

  def ==(right)
    if new_text != right.new_text
      return false
    end

    if new_sexp != right.new_sexp
      return false
    end

    children.zip(right.children).each do |pair|
      if pair[0] != pair[1]
        return false
      end
    end

    return true
  end

  def text path
    get_iter(path)[TEXT]
  end

  def set_text path, new_value
    get_iter(path)[TEXT]= new_value
  end

  def sexp path
    get_iter(path)[SEXP]
  end

  def set_sexp path, new_value
    get_iter(path)[SEXP]= new_value
  end


  def load data, parent
    return if data == nil

    new_node= RatCatcherStore.new
    new_gtk_node= append parent

    case data[0]
    when :str
      new_gtk_node[0]= data[1].inspect
      new_node.new_text= data[1].inspect
      new_node.gtk_tree= new_gtk_node

    when :lit
      new_gtk_node[0]= data[1].inspect
      new_node.new_text= data[1].inspect
      new_node.gtk_tree= new_gtk_node

    when :call
      new_gtk_node[0]= (data[2] == :-@)? '-': data[2].to_s
      new_node.new_text= (data[2] == :-@)? '-': data[2].to_s
      new_node.gtk_tree= new_gtk_node

      if data[1]
        load data[1], new_gtk_node
      end

      data[3][1..-1].each do |arg|
        load arg, new_gtk_node
      end

    when :if
      new_gtk_node[0]= '?:'
      new_node.new_text= '?:'
      new_node.gtk_tree= new_gtk_node
      load data[1], new_gtk_node
      load data[2], new_gtk_node
      load data[3], new_gtk_node

    when :defn
      new_gtk_node[0]= "def #{data[1].to_s}"
      new_node.new_text= "def #{data[1].to_s}"
      new_node.gtk_tree= new_gtk_node
      block_node = data[3][1]
      
      block_node[1..-1].each do |node|
        load node, new_gtk_node
      end

    end
    new_gtk_node[1]= data
  end


  def to_s
    Ruby2Ruby.new.process(sexp("0"))
  end

end

