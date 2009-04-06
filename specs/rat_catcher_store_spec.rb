require 'app/rat_catcher_store'

describe "RatCatcherStore comparing" do

  it "should return true of the operands describe identical trees" do
    left=  RatCatcherStore.new('1+2')
    right= RatCatcherStore.new('1+2')
    left.should == right
  end

  it "should return false if one of the tree is empty and the other isn't" do
    left= RatCatcherStore.new
    right= RatCatcherStore.new('a+b')
    left.should_not == right
  end

end
