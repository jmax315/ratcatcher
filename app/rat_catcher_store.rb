require 'gtk2'
require 'ruby_parser'


class RatCatcherStore < Gtk::TreeStore
  TEXT= 0
  SEXP= 1

  def initialize source_code= ''
    super String, Object

    @parse_tree= RubyParser.new.process source_code

    load @parse_tree, nil
  end

  def ==(right)
      compare_tree_iterators(iter_first, right.iter_first)
  end

  def compare_tree_iterators(left_it, right_it)
    return true if left_it == nil  ||  right_it == nil

    begin
      return false if left_it[TEXT] != right_it[TEXT]
      return false if left_it[SEXP] != right_it[SEXP]
      return false if !compare_tree_iterators(left_it.first_child, right_it.first_child)

      # *Caution* - The behavior of Gtk::TreeIter#next! is _highly_
      # counter-intuitive when reaching the end of the node list. Be
      # very careful and check the Gtk::gnome2::TreeIter docs when
      # modifying the next three lines of code. JAM/CPB 4-Mar-2009
      more_nodes_on_this_level= left_it.next!

      return false if more_nodes_on_this_level != right_it.next!
    end while more_nodes_on_this_level

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

  def load data, parent
    return if data == nil

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
end

