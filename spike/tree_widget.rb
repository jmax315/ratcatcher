#!/usr/bin/env ruby 

require 'gtk2'

window= Gtk::Window.new
window.show

window.signal_connect("destroy") { Gtk.main_quit }


tree_data= Gtk::TreeStore.new(String)

first_row= tree_data.append nil
first_row[0]= "row one"

first_row_child= tree_data.append first_row
first_row_child[0]= "row one point five"

second_row= tree_data.append nil
second_row[0]= "row two"

tree_widget= Gtk::TreeView.new(tree_data)

renderer= Gtk::CellRendererText.new

col= Gtk::TreeViewColumn.new "", renderer, :text => 0
tree_widget.append_column col

window.add tree_widget
window.show_all



Gtk.main

