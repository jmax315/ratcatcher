#!/usr/bin/env ruby 

require 'gtk2'
require 'app/rat_catcher_store'

puts __FILE__
puts Dir.getwd


class SillyTree
  attr_accessor :tree_data, :tree_widget, :renderer, :col

  def initialize
    @tree_data= RatCatcherStore.new 'lambda { "Hi there"[2..5] }'
    @tree_widget= Gtk::TreeView.new(@tree_data)

    @renderer= Gtk::CellRendererText.new
    @col= Gtk::TreeViewColumn.new "", @renderer, :text => 0
    @tree_widget.append_column @col
  end
end


window= Gtk::Window.new

window.signal_connect("destroy") { Gtk.main_quit }

silly_tree= SillyTree.new
window.add silly_tree.tree_widget
window.show_all

Gtk.main

