require 'gtk2'
require 'ruby_parser'


class RatCatcherStore < Gtk::TreeStore
  def initialize source_code
    super String, Object

    @parse_tree= RubyParser.new.process source_code

    load @parse_tree, nil
  end

  def text path
    get_iter(path)[0]
  end

  def sexp path
    get_iter(path)[1]
  end

  def load data, parent
    new_node= append parent

    case data[0]
    when :str
      new_node[0]= data[1].inspect

    when :lit
      new_node[0]= data[1].inspect

    when :call
      new_node[0]= (data[2] == :-@)? '-': data[2].to_s

      if data[1]
        load data[1], new_node
      end

      data[3][1..-1].each do |arg|
        load arg, new_node
      end

    when :if
      new_node[0]= '?:'
      load data[1], new_node
      load data[2], new_node
      load data[3], new_node

    when :defn
      new_node[0]= "def #{data[1].to_s}"
      block_node = data[3][1]
      
      block_node[1..-1].each do |node|
        load node, new_node
      end

    end
    new_node[1]= data
  end

  def [] index
    RatCatcherStoreNode.new @parse_tree[0], @parse_tree[1]
  end
end
