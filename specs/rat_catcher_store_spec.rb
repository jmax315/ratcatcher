require 'app/rat_catcher_store'

describe "RatCatcherStore comparing" do

  it "should return true of the operands describe identical trees" do
    left=  RatCatcherStore.parse('1+2')
    right= RatCatcherStore.parse('1+2')
    left.should == right
  end

  it "should return false if one of the tree is empty and the other isn't" do
    left= RatCatcherStore.parse
    right= RatCatcherStore.parse('a+b')
    left.should_not == right
  end

  it "should return false when the trees are different" do
    left=  RatCatcherStore.parse('1+2')
    right= RatCatcherStore.parse('2+2')
    left.should_not == right
  end


end


describe "the path_reference method" do
  before :each do
    @tree= RatCatcherStore.parse '(1+2-3)*4'
  end

  it "should find the root node" do
    @tree.path_reference('').should == @tree
  end

  it "should find the 0 node" do
    @tree.path_reference('0').should == @tree[0]
  end

  it "should find the 1 node" do
    @tree.path_reference('1').should == @tree[1]
  end

  it "should find the 0:0 node" do
    @tree.path_reference('0:0').should == @tree[0][0]
  end

  it "should find the 0:0:0 node" do
    @tree.path_reference('0:0:0').should == @tree[0][0][0]
  end

  it "should find the 0:1 node" do
    @tree.path_reference('0:1').should == @tree[0][1]
  end

  it "should find the 0:0:1 node" do
    @tree.path_reference('0:0:1').should == @tree[0][0][1]
  end

end
