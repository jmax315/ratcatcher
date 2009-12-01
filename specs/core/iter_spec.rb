describe 'calling a method with a block' do
  before :each do
    @store= RatCatcherStore.parse('a_method { 1 }')
  end

  it "should have three children" do
    @store.children.size.should == 3
  end

  it "should generate the corret sexp" do
    @store.sexp.should == s(:iter, s(:call, nil, :a_method, s(:arglist)), nil, s(:lit, 1))
  end
end
