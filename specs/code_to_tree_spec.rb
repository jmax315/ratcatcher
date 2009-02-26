require 'app/rat_catcher_store'
require 'specs/tree_like_matcher'

describe 'tree for the numeric literal 1' do
  before :each do
    @tree= RatCatcherStore.new '1'
  end

  it 'should have one node containing 1 as display text' do
    @tree.text('0').should == '1'
  end

  it 'should have one node containing s(:lit, 1) as its sexp' do
    @tree.sexp('0').should be_a_tree_like(s(:lit, 1))
  end
end


describe 'tree for the string literal "ferd"' do
   before :each do
     @tree= RatCatcherStore.new '"ferd"'
   end

  it "should have one node containing 'ferd' as display text" do
    @tree.text('0').should == '"ferd"'
  end

  it "should have one node containing s(:str, 'ferd') as its sexp" do
    @tree.sexp('0').should be_a_tree_like(s(:str, "ferd"))
  end
end


describe 'tree for the expression 1+2' do
  before :each do
    @tree= RatCatcherStore.new '1+2'
  end

  it "should have one top-level node containing + as display text" do
    @tree.text('0').should == '+'
  end

  it "should have a call node with 1 as the recipient and + as the method" do
    @tree.sexp('0').should be_a_tree_like(s(:call, :_, :+, :_))
  end

  it "should have a node at 0:0 containing '1' as display text" do
    @tree.text('0:0').should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) as its sexp" do
    @tree.sexp('0:0').should be_a_tree_like(s(:lit, 1))
  end

  it "should have a node at 0:1 containing '2' as display text" do
    @tree.text('0:1').should == '2'
  end

  it "should have a node at 0:1 containing s(:lit, 2) as its sexp" do
    @tree.sexp('0:1').should be_a_tree_like(s(:lit, 2))
  end

end


describe 'tree for the expression 1-2' do
  before :each do
    @tree= RatCatcherStore.new '1-2'
  end

  it "should have one top-level node containing - as display text" do
    @tree.text('0').should == '-'
  end

  it "should have a call node with 1 as the recepient and - as the method" do
    @tree.sexp('0').should be_a_tree_like(s(:call, :_, :-, :_))
  end

  it "should have a node at 0:0 containing '1' as display text" do
    @tree.text('0:0').should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) as its sexp" do
    @tree.sexp('0:0').should be_a_tree_like(s(:lit, 1))
  end

  it "should have a node at 0:1 containing '2' as display text" do
    @tree.text('0:1').should == '2'
  end

  it "should have a node at 0:1 containing s(:lit, 2) as its sexp" do
    @tree.sexp('0:1').should be_a_tree_like(s(:lit, 2))
  end
end


describe 'tree for the expression 1+(2-3)' do
  before :each do
    @tree= RatCatcherStore.new '1+(2-3)'
  end

  it "should have a node at 0 containing '+' as display text" do
    @tree.text('0').should == '+'
  end

  it "should have a call node at 0 to 1 with the method +" do
    @tree.sexp('0').should be_a_tree_like(s(:call, :_, :+, :_))
  end

  it "should have a call node at 0:3:1 to 2 with the method -" do
    @tree.sexp('0')[3][1].should be_a_tree_like(s(:call, :_, :-, :_))
  end

  it "should have a node at 0:0 containing '1' as display text" do
    @tree.text('0:0').should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) as its sexp" do
    @tree.sexp('0:0').should be_a_tree_like(s(:lit, 1))
  end

  it "should have a node at 0:1 containing '-' as display text" do
    @tree.text('0:1').should == '-'
  end

  it "should have a call node at 0:1 to 2 with the method -" do
    @tree.sexp('0:1').should be_a_tree_like(s(:call, :_, :-, :_))
  end

  it "should have a node at 0:1:0 containing '2' as display text" do
    @tree.text('0:1:0').should == '2'
  end

  it "should have a node at 0:1:0 containing s(:lit, 2) as its sexp" do
    @tree.sexp('0:1:0').should be_a_tree_like(s(:lit, 2))
  end

  it "should have a node at 0:1:1 containing '3' as display text" do
    @tree.text('0:1:1').should == '3'
  end

  it "should have a node at 0:1:1 containing s(:lit, 3) as its sexp" do
    @tree.sexp('0:1:1').should be_a_tree_like(s(:lit, 3))
  end

end


describe 'tree for the expression (1+2)*3' do
  before :each do
    @tree= RatCatcherStore.new '(1+2)*3'
  end

  it "should have a node at 0 containing '*' as display text" do
    @tree.text('0').should == '*'
  end

  it "should have a call node at 0 to the object returned from a call with operator '*'" do
    @tree.sexp('0').should be_a_tree_like(s(:call, s(:call, :_, :+, :_), :*, :_))
  end

  it "should have a node at 0:0 containing '+' as display text" do
    @tree.text('0:0').should == '+'
  end

  it "should have a call node at 0:0 to the + method" do
    @tree.sexp('0:0').should be_a_tree_like(s(:call, :_, :+, :_))
  end

  it "should have a node at 0:1 containing '3' as display text" do
    @tree.text('0:1').should == '3'
  end

  it "should have a node at 0:1 containing s(:lit, 3) as its sexp" do
    @tree.sexp('0:1').should be_a_tree_like(s(:lit, 3))
  end
  
  it "should have a node at 0:0:0 containing '1' as display text" do
    @tree.text('0:0:0').should == '1'
  end
  
  it "should have a node at 0:0:0 containing s(:lit, 2) as its sexp" do
    @tree.sexp('0:0:0').should be_a_tree_like(s(:lit, 1))
  end

  it "should have a node at 0:0:1 containing '2' as display text" do
    @tree.text('0:0:1').should == '2'
  end

  it "should have a node at 0:1:1 containing s(:lit, 2) as its sexp" do
    @tree.sexp('0:0:1').should be_a_tree_like(s(:lit, 2))
  end
end


describe 'tree for the expression f' do
  before :each do
    @tree= RatCatcherStore.new 'f'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text('0').should == 'f'
  end

  it "should have a call node to the method f" do
    @tree.sexp('0').should be_a_tree_like(s(:call, nil, :f, s(:arglist)))
  end
end


describe 'tree for the expression f()' do
  before :each do
    @tree= RatCatcherStore.new 'f()'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text('0').should == 'f'
  end

  it "should have a call node to the method f" do
    @tree.sexp('0').should be_a_tree_like(s(:call, nil, :f, s(:arglist)))
  end
end


describe 'tree for the expression f(2,3)' do
  before :each do
    @tree= RatCatcherStore.new 'f(2,3)'
  end

  it "should have a top-level node containing f as display text" do
    @tree.text('0').should == 'f'
  end

  it "should have a top-level call node to the f method" do
     @tree.sexp('0').should be_a_tree_like(s(:call, nil, :f, :_))
  end

  it "should have a node at 0:0 containing '2' as display text" do
    @tree.text('0:0').should == '2'
  end

  it "should have a node at 0:0 containing" do
    @tree.sexp('0:0').should be_a_tree_like(s(:lit, 2))
  end

  it "should have a node at 0:1 containing '3' as display text" do
    @tree.text('0:1').should == '3'
  end

  it "should have a node at 0:1 containing s(:lit, 3) as its sexp" do
    @tree.sexp('0:1').should be_a_tree_like(s(:lit, 3))
  end
end


describe 'tree for the expression f(7)' do
  before :each do
    @tree= RatCatcherStore.new 'f(7)'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text('0').should == 'f'
  end

  it "should have a top-level call node to the method f" do
    @tree.sexp('0').should be_a_tree_like(s(:call, nil, :f, :_))
  end

  it "should have a node at 0:0 containing '7' as display text" do
    @tree.text('0:0').should == '7'
  end

  it "should have a literal node for the value 7 at 0:0" do
    @tree.sexp('0:0').should be_a_tree_like(s(:lit, 7))
  end
end


describe 'tree for the expression f(3,6,9)' do
  before :each do
    @tree= RatCatcherStore.new 'f(3,6,9)'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text('0').should == 'f'
  end

  it "should have a top-level call node to the method f" do
     @tree.sexp('0').should be_a_tree_like(s(:call, nil, :f, :_))
  end

  it "should have a node at 0:0 containing '3' as display text" do
    @tree.text('0:0').should == '3'
  end

  it "should have a node at 0:0 containing" do
    @tree.sexp('0:0').should be_a_tree_like(s(:lit, 3))
  end

  it "should have a node at 0:1 containing '6' as display text" do
    @tree.text('0:1').should == '6'
  end

  it "should have a node at 0:1 containing s(:lit, 6) as its sexp" do
    @tree.sexp('0:1').should be_a_tree_like(s(:lit, 6))
  end

  it "should have a node at 0:2 containing '9' as display text" do
    @tree.text('0:2').should == '9'
  end

  it "should have a node at 0:2 containing s(:lit, 9) as its sexp" do
    @tree.sexp('0:2').should be_a_tree_like(s(:lit, 9))
  end
end


describe 'tree for the expression - 8' do
  before :each do
    @tree= RatCatcherStore.new '- 8'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text('0').should == '-'
  end

  it "should have a top-level call node to the -@ method" do
     @tree.sexp('0').should be_a_tree_like(s(:call, :_, :-@, :_))
  end

  it "should have a node at 0:0 containing '8' as display text" do
    @tree.text('0:0').should == '8'
  end

  it "should have a node at 0:0 containing
      s(:lit, 8)
      as its sexp" do
    @tree.sexp('0:0').should be_a_tree_like(s(:lit, 8))
  end

end


describe 'tree for the expression 75? 0: 2' do
  before :each do
    @tree= RatCatcherStore.new '75? 0: 2'
  end

  it "should have one top-level node containing ?: as display text" do
    @tree.text('0').should == '?:'
  end

  it "should have a top-level if node" do
     @tree.sexp('0').should be_a_tree_like(s(:if, :_, :_, :_))
  end

  it "should have a node at 0:0 containing '75' as display text" do
    @tree.text('0:0').should == '75'
  end

  it "should have a literal node for 75 at 0:0 containing" do
    @tree.sexp('0:0').should be_a_tree_like(s(:lit, 75))
  end

  it "should have a node at 0:1 containing '0' as display text" do
    @tree.text('0:1').should == '0'
  end

  it "should have a literal node for 0 at 0:1" do
    @tree.sexp('0:1').should be_a_tree_like(s(:lit, 0))
  end

  it "should have a node at 0:2 containing '2' as display text" do
    @tree.text('0:2').should == '2'
  end

  it "should have a literal node for 2 at 0:2" do
    @tree.sexp('0:2').should be_a_tree_like(s(:lit, 2))
  end

end

