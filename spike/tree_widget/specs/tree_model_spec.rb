require 'app/silly_tree'

describe "The model for our spike's tree data" do
  it "should have 'row one' in the first node" do
    @the_tree= SillyTree.new
    @the_tree.tree_data.get_iter("0")[0].should == "row one"
  end

  it "should have 'row two' in the second node" do
    @the_tree= SillyTree.new
    @the_tree.tree_data.get_iter("1")[0].should == "row two"
  end

  it "should have 'row one point five' in the first node's first child" do
    @the_tree= SillyTree.new
    @the_tree.tree_data.get_iter("0:0")[0].should == "row one point five"
  end
end
