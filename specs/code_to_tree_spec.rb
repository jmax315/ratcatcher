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


# def it_should_have_a_node(expected_type,
#                           expected_value,
#                           position,
#                           ruby_code)

  
#   it "should have a #{expected_type} node at #{position.inspect}" do
#     store= RatCatcherStore.new ruby_code
#     store[position].node_type.should == expected_type
#   end

#   it "should have a node with value #{expected_value} at #{position.inspect}" do
#     store= RatCatcherStore.new ruby_code
#     store[position].node_value.should == expected_value
#   end
# end


# def it_should_have_a_node_with_type(expected_type,
#                                     position,
#                                     ruby_code)

  
#   it "should have a #{expected_type} node at #{position.inspect}" do
#     store= RatCatcherStore.new ruby_code
#     store[position].node_type.should == expected_type
#   end
# end


# describe "transforming Ruby code to data in a Gtk TreeStore" do
#   it_should_have_a_node :lit,      1, [], '1'
#   it_should_have_a_node :lit,      2, [], '2'
#   it_should_have_a_node :str, "ferd", [], "'ferd'"
#   it_should_have_a_node :lit, :ferd,  [], ':ferd'
#   it_should_have_a_node :lit,   1.1,  [], '1.1'

# end

