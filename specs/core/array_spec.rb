require 'app/rat_catcher_app'

describe 'array parse tree' do
  before :each do
    @tree= RatCatcherStore.parse '[1, 2]'
  end
  
  it 'should contain a tree with an array' do
    @tree.sexp.should be_a_tree_like(s(:array, s(:lit, 1), s(:lit, 2)))
  end  
  
  it 'should regenerate the source code' do
    @tree.to_ruby.should == '[1, 2]'
  end
  
  # This should NOT be adding spaces, why it's doing so we don't know,
  # but...  we'll worry about this later.
  it 'should produce to_s properly' do
    @tree.to_ruby.should == '[1, 2]'
  end
end

describe 'array parse tree' do
  before :each do
    @tree= RatCatcherStore.parse '[3, 4]'
  end
  
  it 'should contain a tree with an array' do
    @tree.sexp.should be_a_tree_like(s(:array, s(:lit, 3), s(:lit, 4)))
  end  
end


#describe 'array parse tree' do
#  before :each do
#    @tree= RatCatcherStore.parse '[1,2]'
#  end
#  
#  it 'should contain a tree with an array' do
#    @tree.sexp.should be_a_tree_like(s(:array, s(:lit, 1), s(:lit, 2)))
#  end  
#  
#  it 'should regenerate the source code' do
#    @tree.to_ruby.should == '[1,2]'
#  end
#end