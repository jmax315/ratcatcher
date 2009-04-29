require 'app/rat_catcher_store_gtk_wrapper'

describe "Populating the RatCatcharStoreGtkWrapper from a RatCatcherStore" do

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


describe "Updating the RatCatcharStoreGtkWrapper from a RatCatcherStore" do
  before :each do
    @store= RatCatcherStore.parse('2+4*6')
    @wrapper= RatCatcherStoreGtkWrapper.new(@store)
    @new_store= RatCatcherStore.parse('1-1')
    @wrapper.store_changed(@new_store)
  end

  it "should update the text when the store_changed method is called" do
    @wrapper.get_iter("0")[0].should == '-'
  end

  it "should update the store back pointer when the store_changed method is called" do
    @wrapper.get_iter("0")[1].should == @new_store
  end

end
