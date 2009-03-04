require 'app/rat_catcher_store'

describe "RatCatcherStore comparing" do

  it "should return true of the operands describe identical trees" do
    left=  RatCatcherStore.new('1+2')
    right= RatCatcherStore.new('1+2')
    left.should == right
  end

end
