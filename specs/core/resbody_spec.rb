describe 'ResbodyStore (the rescue clause of a begin/rescue/end block' do
  before :each do
    res_store= RatCatcherStore.parse('begin; 4; rescue; 5; end')
    @store= res_store.children[1]
  end

  it "should have two children" do
    @store.children.size.should == 2
  end

  it "should return the correct sexp" do
    @store.sexp.should == s(:resbody, s(:array), s(:lit, 5))
  end
end
