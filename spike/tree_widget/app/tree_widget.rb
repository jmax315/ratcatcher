#!/usr/bin/env ruby 

require 'gtk2'
require 'silly_tree'


window= Gtk::Window.new

window.signal_connect("destroy") { Gtk.main_quit }

silly_tree= SillyTree.new
window.add silly_tree.tree_widget
window.show_all

Gtk.main

