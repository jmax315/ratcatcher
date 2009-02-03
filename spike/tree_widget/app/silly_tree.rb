require 'gtk2'

class SillyTree
  attr_accessor :tree_data, :first_row, :second_row, :tree_widget, :renderer, :col

  def initialize
    @tree_data= Gtk::TreeStore.new(String)

    @first_row= @tree_data.append nil
    @first_row[0]= "row one"

    @first_row_child= @tree_data.append @first_row
    @first_row_child[0]= "row one point five"

    @second_row= @tree_data.append nil
    @second_row[0]= "row two"

    @tree_widget= Gtk::TreeView.new(@tree_data)

    @renderer= Gtk::CellRendererText.new

    @col= Gtk::TreeViewColumn.new "", @renderer, :text => 0
    @tree_widget.append_column @col
  end
end
