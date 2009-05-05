require 'app/rat_catcher_store_gtk_wrapper'

describe "Populating the RatCatcherStoreGtkWrapper from a RatCatcherStore" do

  before :each do
    @store= RatCatcherStore.parse('2+4*6')
    @wrapper= RatCatcherStoreGtkWrapper.new(@store)
  end

  it "should populate the root node from the root node" do
    @wrapper.get_iter("0")[0].should == @store.text
  end

  it "should populate the second child from the second child" do
    @wrapper.get_iter("0:1")[0].should == @store[1].text
  end

  it "should register the Gtk::TreeStore to get notified when the RatCatcherStore changes" do
    @store.listeners.should include(@wrapper)
  end

  it "should update the wrapper when the store changes" do
    @store.sexp= s(:call, s(:lit, 1), :-, s(:arglist, s(:lit, 1)))

    @wrapper.get_iter("0")[0].should == '-'
    @wrapper.get_iter("0")[1].should == @store
  end

end


describe "Updating the RatCatcherStoreGtkWrapper from a RatCatcherStore" do
  before :each do
    @store= RatCatcherStore.parse('3+6*9')
    @wrapper= RatCatcherStoreGtkWrapper.new(@store)
    new_store= RatCatcherStore.parse('1-1')
    @store.sexp= new_store.sexp
  end

  it "should update the text when the store_changed method is called" do
    @wrapper.get_iter("0")[0].should == '-'
  end

  it "should update the store back pointer when the store_changed method is called" do
    @wrapper.get_iter("0")[1].should == @store
  end
end


describe "Updating the RatCatcherStoreGtkWrapper from a RatCatcherStore leaf node" do
  before :each do
    @store= RatCatcherStore.parse('5+10*15')
    @wrapper= RatCatcherStoreGtkWrapper.new(@store)
    @new_store= RatCatcherStore.parse('1-2')
    @store[1][1].sexp= @new_store.sexp
  end

  it "should parse the new expression correctly" do
    @new_store.sexp.should == s(:call, s(:lit, 1), :-, s(:arglist, s(:lit, 2)))
  end

  it "should copy the new expression correctly" do
    @store[1][1].sexp.should == s(:call, s(:lit, 1), :-, s(:arglist, s(:lit, 2)))
  end

  it "should have a '1' in the first child's text" do
    @new_store[0].sexp.should == s(:lit, 1)
  end

  it "should have a '1' in the first child's text" do
    @store[1][1][0].sexp.should == s(:lit, 1)
  end

  it "should update the text when the store_changed method is called" do
    @wrapper.get_iter("0:1:1")[0].should == '-'
  end

  it "should update the store back pointer when the store_changed method is called" do
    @wrapper.get_iter("0:1:1")[1].should == @store[1][1]
  end

  it "should create a new left child node to match the sexp" do
    @wrapper.get_iter("0:1:1:0")[0].should == '1'
  end

  it "should create a new left child node to match the sexp" do
    @wrapper.get_iter("0:1:1:0")[1].should == @store[1][1][0]
  end

  it "should create a new left child node to match the sexp" do
    @wrapper.get_iter("0:1:1:1")[0].should == '2'
  end

  it "should create a new left child node to match the sexp" do
    @wrapper.get_iter("0:1:1:1")[1].should == @store[1][1][1]
  end
end


describe "Updating the RatCatcherStoreGtkWrapper from a RatCatcherStore interior node" do
  before :each do
    @store= RatCatcherStore.parse('5+10*15')
    @wrapper= RatCatcherStoreGtkWrapper.new(@store)
    @new_store= RatCatcherStore.parse('1-2')
    @store[1][1].sexp= @new_store.sexp
  end

#  it "should make the developers continue here"

#   it "should parse the new expression correctly" do
#     @new_store.sexp.should == s(:call, s(:lit, 1), :-, s(:arglist, s(:lit, 2)))
#   end

#   it "should copy the new expression correctly" do
#     @store[1][1].sexp.should == s(:call, s(:lit, 1), :-, s(:arglist, s(:lit, 2)))
#   end

#   it "should have a '1' in the first child's text" do
#     @new_store[0].sexp.should == s(:lit, 1)
#   end

#   it "should have a '1' in the first child's text" do
#     @store[1][1][0].sexp.should == s(:lit, 1)
#   end

#   it "should update the text when the store_changed method is called" do
#     @wrapper.get_iter("0:1:1")[0].should == '-'
#   end

#   it "should update the store back pointer when the store_changed method is called" do
#     @wrapper.get_iter("0:1:1")[1].should == @store[1][1]
#   end

#   it "should create a new left child node to match the sexp" do
#     @wrapper.get_iter("0:1:1:0")[0].should == '1'
#   end

#   it "should create a new left child node to match the sexp" do
#     @wrapper.get_iter("0:1:1:0")[1].should == @store[1][1][0]
#   end

#   it "should create a new left child node to match the sexp" do
#     @wrapper.get_iter("0:1:1:1")[0].should == '2'
#   end

#   it "should create a new left child node to match the sexp" do
#     @wrapper.get_iter("0:1:1:1")[1].should == @store[1][1][1]
#   end
end
