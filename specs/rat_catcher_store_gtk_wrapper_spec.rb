

describe "Populating the RatCatcharStoreGtkWrapper from a RatCatcherStore" do

  before :each do
    @store= RatCatcherStore.parse('2+4+6')
    @wrapper= RatCatcherStoreGtkWrapper.new(@store)
  end

  it "should populate the root node from the root node" do
    @wrapper.get_iter("0")[0].should == @store.text
  end

  it "should populate the second child from the second child" do
    @wrapper.get_iter("0:1")[0].should == @store[1].text
  end

end
