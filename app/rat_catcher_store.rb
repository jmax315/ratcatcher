require 'gtk2'
require 'ruby_parser'


class RatCatcherStore < Gtk::TreeStore
  def initialize source_code
    super Object

    @parse_tree= RubyParser.new.process source_code

    load @parse_tree, nil
  end

  def load data, parent
    new_node= append parent
    if data.kind_of?(Sexp)
      new_node[0]= data[0]
      data[1..-1].each do |child|
        load child, new_node
      end
    else
      new_node[0]= data
    end
  end

  def [] index
    RatCatcherStoreNode.new @parse_tree[0], @parse_tree[1]
  end
end
