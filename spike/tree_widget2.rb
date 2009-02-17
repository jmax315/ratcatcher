#!/usr/bin/env ruby 

require 'gtk2'
require 'app/rat_catcher_store'

class SillyTree
  attr_accessor :tree_data, :tree_widget, :renderer, :col

  def initialize
    @tree_data= RatCatcherStore.new 'f(12, 6+4)'
    @tree_widget= Gtk::TreeView.new(@tree_data)

    @renderer= Gtk::CellRendererText.new

    @col= Gtk::TreeViewColumn.new "", @renderer, :text => 0

    @tree_widget.append_column @col
  end
end


window= Gtk::Window.new
window.set_default_size(500,500)

window.signal_connect("destroy") { Gtk.main_quit }

silly_tree= SillyTree.new
window.add silly_tree.tree_widget
window.show_all

Gtk.main

