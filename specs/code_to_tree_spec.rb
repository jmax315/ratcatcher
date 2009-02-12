require 'app/rat_catcher_store'


describe 'turning a numeric literal into a RatCatcherStrore' do

  before :each do
    @tree= RatCatcherStore.new '1'
  end

  it "should create a RatCatcherStore with one node of type :lit" do
    @tree.get_iter("0")[0].should == :lit
  end

  it "should create a RatCatcherStore with one node with a child of 1" do
    @tree.get_iter("0:0")[0].should == 1
  end

end


describe 'turning a string into a RatCatcherStrore' do

  before :each do
    @tree= RatCatcherStore.new '"ferd"'
  end

  it "should create a RatCatcherStore with one node of type :lit" do
    @tree.get_iter("0")[0].should == :str
  end

  it "should create a RatCatcherStore with one node with a child of 1" do
    @tree.get_iter("0:0")[0].should == "ferd"
  end

end


describe 'turning a simple expression into a RatCatcherStrore' do

  before :each do
    @tree= RatCatcherStore.new '1+2'
  end

  it "should create a RatCatcherStore with one node of type :call" do
    @tree.get_iter("0")[0].should == :call
  end

  it "should create a RatCatcherStore with a child at 0:0 of type :lit" do
    @tree.get_iter("0:0")[0].should == :lit
  end

  it "should create a RatCatcherStore with a child at 0:1 with value 1" do
    @tree.get_iter("0:0:0")[0].should == 1
  end

  it "should create a RatCatcherStore with a child at 2 with value :+" do
    @tree.get_iter("0:1")[0].should == :+
  end

  it "should create a RatCatcherStore with a child at 0:3 with value :arglist" do
    @tree.get_iter("0:2")[0].should == :arglist
  end

end
