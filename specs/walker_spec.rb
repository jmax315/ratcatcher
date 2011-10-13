require File.dirname(__FILE__) + "/../app/rat_catcher_store"

describe "The RatCatcherStore#walk method" do
  before :each do
    @store= RatCatcherStore.parse(
%q{
class AClass;
  def the_method
  end
end
})
  end

  it "should return nil when passed an empty path components array" do
    @store.walk([]).should be_nil
  end

  it "should find the class definition" do
    pending
    @store.walk(['AClass']).should == @store
  end

  it "should not find anything with bogus path components" do
    @store.walk(['Bogus']).should be_nil
  end

  it "should find the_method" do
    pending
    @store.walk(['AClass', 'the_method']).sexp.should == @store.sexp[3][1]
  end

  it "should not find a_bogus_method" do
    @store.walk(['AClass', 'a_bogus_method']).should be_nil
  end

  it "should not find ." do
    @store.walk(['.']).should be_nil
  end
end


describe "Finding a method from a method node" do
  before :each do
    @store= RatCatcherStore.parse(
%q{
def the_method
end
})
  end

  it "should return nil when passed an empty path components array" do
    @store.walk([]).should be_nil
  end

  it "should find the method definition" do
    pending
    @store.walk(['the_method']).should == @store
  end

  it "should not find anything with bogus path components" do
    @store.walk(['bogus']).should be_nil
  end

  it "should not find ." do
    @store.walk(['.']).should be_nil
  end
end
