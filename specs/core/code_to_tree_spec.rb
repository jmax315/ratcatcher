require 'app/rat_catcher_store'
require 'specs/tree_like_matcher'


describe 'tree for no input' do
  before :each do
    @tree= RatCatcherStore.parse ''
  end

  it 'should have '' for text' do
    @tree.text.should == ""
  end

  it 'should have nil for sexp' do
    @tree.sexp.should be_nil
  end

  it 'should have no children' do
    @tree.children.should be_empty
  end
end

describe 'tree for null (zero-length) input' do
  before :each do
    @tree= RatCatcherStore.parse ''
  end

  it 'should have '' for text' do
    @tree.text.should == ""
  end

  it 'should have nil for sexp' do
    @tree.sexp.should be_nil
  end

  it 'should have no children' do
    @tree.children.should be_empty
  end
end

describe 'tree for the numeric literal 1' do
  before :each do
    @tree= RatCatcherStore.parse '1'
  end

  it 'should have one node containing 1 as display text' do
    @tree.text.should == '1'
  end

  it 'should have one node containing s(:lit, 1) as its sexp' do
    @tree.sexp.should be_a_tree_like(s(:lit, 1))
  end
end


describe 'tree for the string literal "ferd"' do
   before :each do
     @tree= RatCatcherStore.parse '"ferd"'
   end

  it "should have one node containing 'ferd' as display text" do
    @tree.text.should == 'ferd'
  end

  it "should have one node containing s(:str, 'ferd') as its sexp" do
    @tree.sexp.should be_a_tree_like(s(:str, "ferd"))
  end
end


describe 'tree for the symbol literal :foo' do
   before :each do
     @tree= RatCatcherStore.parse ':foo'
   end

  it "should have one node containing ':foo' as display text" do
    @tree.text.should == ':foo'
  end

  it "should have one node containing s(:lit, :foo) as its sexp" do
    @tree.sexp.should be_a_tree_like(s(:lit, :foo))
  end
end


describe 'tree for the expression 1+2' do
  before :each do
    @tree= RatCatcherStore.parse '1+2'
  end

  it "should have one top-level node containing + as display text" do
    @tree.text.should == '+'
  end

  it "should have a call node with 1 as the recipient and + as the method" do
    @tree.sexp.should be_a_tree_like(s(:call, :_, :+, :_))
  end

  it "should have a node at 0:0 containing '1' as display text" do
    @tree.children[0].text.should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) as its sexp" do
    @tree[0].sexp.should be_a_tree_like(s(:lit, 1))
  end

  it "should have a node at 0:1 containing '2' as display text" do
    @tree[1].text.should == '2'
  end

  it "should have a node at 0:1 containing s(:lit, 2) as its sexp" do
    @tree[1].sexp.should be_a_tree_like(s(:lit, 2))
  end

end


describe 'tree for the expression 1-2' do
  before :each do
    @tree= RatCatcherStore.parse '1-2'
  end

  it "should have one top-level node containing - as display text" do
    @tree.text.should == '-'
  end

  it "should have a call node with 1 as the recepient and - as the method" do
    @tree.sexp.should be_a_tree_like(s(:call, :_, :-, :_))
  end

  it "should have a node at 0:0 containing '1' as display text" do
    @tree[0].text.should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) as its sexp" do
    @tree[0].sexp.should be_a_tree_like(s(:lit, 1))
  end

  it "should have a node at 0:1 containing '2' as display text" do
    @tree[1].text.should == '2'
  end

  it "should have a node at 0:1 containing s(:lit, 2) as its sexp" do
    @tree[1].sexp.should be_a_tree_like(s(:lit, 2))
  end
end


describe 'tree for the expression 1+(2-3)' do
  before :each do
    @tree= RatCatcherStore.parse '1+(2-3)'
  end

  it "should have a node at 0 containing '+' as display text" do
    @tree.text.should == '+'
  end

  it "should have a call node at 0 to 1 with the method +" do
    @tree.sexp.should be_a_tree_like(s(:call, :_, :+, :_))
  end

  it "should have a call node at 0:3:1 to 2 with the method -" do
    @tree.sexp[3][1].should be_a_tree_like(s(:call, :_, :-, :_))
  end

  it "should have a node at 0:0 containing '1' as display text" do
    @tree[0].text.should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) as its sexp" do
    @tree[0].sexp.should be_a_tree_like(s(:lit, 1))
  end

  it "should have a node at 0:1 containing '-' as display text" do
    @tree[1].text.should == '-'
  end

  it "should have a call node at 0:1 to 2 with the method -" do
    @tree[1].sexp.should be_a_tree_like(s(:call, :_, :-, :_))
  end

  it "should have a node at 0:1:0 containing '2' as display text" do
    @tree[1][0].text.should == '2'
  end

  it "should have a node at 0:1:0 containing s(:lit, 2) as its sexp" do
    @tree[1][0].sexp.should be_a_tree_like(s(:lit, 2))
  end

  it "should have a node at 0:1:1 containing '3' as display text" do
    @tree[1][1].text.should == '3'
  end

  it "should have a node at 0:1:1 containing s(:lit, 3) as its sexp" do
    @tree[1][1].sexp.should be_a_tree_like(s(:lit, 3))
  end

end


describe 'tree for the expression (1+2)*3' do
  before :each do
    @tree= RatCatcherStore.parse '(1+2)*3'
  end

  it "should have a node at 0 containing '*' as display text" do
    @tree.text.should == '*'
  end

  it "should have a call node at 0 to the object returned from a call with operator '*'" do
    @tree.sexp.should be_a_tree_like(s(:call, s(:call, :_, :+, :_), :*, :_))
  end

  it "should have a node at 0:0 containing '+' as display text" do
    @tree[0].text.should == '+'
  end

  it "should have a call node at 0:0 to the + method" do
    @tree[0].sexp.should be_a_tree_like(s(:call, :_, :+, :_))
  end

  it "should have a node at 0:1 containing '3' as display text" do
    @tree[1].text.should == '3'
  end

  it "should have a node at 0:1 containing s(:lit, 3) as its sexp" do
    @tree[1].sexp.should be_a_tree_like(s(:lit, 3))
  end
  
  it "should have a node at 0:0:0 containing '1' as display text" do
    @tree[0][0].text.should == '1'
  end
  
  it "should have a node at 0:0:0 containing s(:lit, 2) as its sexp" do
    @tree[0][0].sexp.should be_a_tree_like(s(:lit, 1))
  end

  it "should have a node at 0:0:1 containing '2' as display text" do
    @tree[0][1].text.should == '2'
  end

  it "should have a node at 0:1:1 containing s(:lit, 2) as its sexp" do
    @tree[0][1].sexp.should be_a_tree_like(s(:lit, 2))
  end
end


describe 'tree for the expression f' do
  before :each do
    @tree= RatCatcherStore.parse 'f'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text.should == 'f'
  end

  it "should have a call node to the method f" do
    @tree.sexp.should be_a_tree_like(s(:call, nil, :f, s(:arglist)))
  end
end


describe 'tree for the expression f()' do
  before :each do
    @tree= RatCatcherStore.parse 'f()'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text.should == 'f'
  end

  it "should have a call node to the method f" do
    @tree.sexp.should be_a_tree_like(s(:call, nil, :f, s(:arglist)))
  end
end


describe 'tree for the expression f(2,3)' do
  before :each do
    @tree= RatCatcherStore.parse 'f(2,3)'
  end

  it "should have a top-level node containing f as display text" do
    @tree.text.should == 'f'
  end

  it "should have a top-level call node to the f method" do
     @tree.sexp.should be_a_tree_like(s(:call, nil, :f, :_))
  end

  it "should have a node at 1 containing '2' as display text" do
    @tree[1].text.should == '2'
  end

  it "should have a node at 1 containing a literal 2" do
    @tree[1].sexp.should be_a_tree_like(s(:lit, 2))
  end

  it "should have a node at 2 containing '3' as display text" do
    @tree[2].text.should == '3'
  end

  it "should have a node at 2 containing the literal 3" do
    @tree[2].sexp.should be_a_tree_like(s(:lit, 3))
  end
end


describe 'tree for the expression f(7)' do
  before :each do
    @tree= RatCatcherStore.parse 'f(7)'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text.should == 'f'
  end

  it "should have a top-level call node to the method f" do
    @tree.sexp.should be_a_tree_like(s(:call, nil, :f, :_))
  end

  it "should have a node at 1 containing '7' as display text" do
    @tree[1].text.should == '7'
  end

  it "should have a node at 1 containing the literal 7" do
    @tree[1].sexp.should be_a_tree_like(s(:lit, 7))
  end
end


describe 'tree for the expression f(3,6,9)' do
  before :each do
    @tree= RatCatcherStore.parse 'f(3,6,9)'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text.should == 'f'
  end

  it "should have a top-level call node to the method f" do
     @tree.sexp.should be_a_tree_like(s(:call, nil, :f, :_))
  end

  it "should have a node at 1 containing '3' as display text" do
    @tree[1].text.should == '3'
  end

  it "should have a node at 0:0 containing" do
    @tree[1].sexp.should be_a_tree_like(s(:lit, 3))
  end

  it "should have a node at 0:1 containing '6' as display text" do
    @tree[2].text.should == '6'
  end

  it "should have a node at 0:1 containing s(:lit, 6) as its sexp" do
    @tree[2].sexp.should be_a_tree_like(s(:lit, 6))
  end

  it "should have a node at 0:2 containing '9' as display text" do
    @tree[3].text.should == '9'
  end

  it "should have a node at 0:2 containing s(:lit, 9) as its sexp" do
    @tree[3].sexp.should be_a_tree_like(s(:lit, 9))
  end
end


describe 'tree for the expression - 8' do
  before :each do
    @tree= RatCatcherStore.parse '- 8'
  end

  it "should have one top-level node containing f as display text" do
    @tree.text.should == '-'
  end

  it "should have a top-level call node to the -@ method" do
     @tree.sexp.should be_a_tree_like(s(:call, :_, :-@, :_))
  end

  it "should have a node at 0:0 containing '8' as display text" do
    @tree[0].text.should == '8'
  end

  it %q{should have a node at 0:0 containing
      s(:lit, 8)
      as its sexp} do
    @tree[0].sexp.should be_a_tree_like(s(:lit, 8))
  end

end


describe 'tree for the expression 75? 0: 2' do
  before :each do
    @tree= RatCatcherStore.parse '75? 0: 2'
  end

  it "should have one top-level node containing ?: as display text" do
    @tree.text.should == '?:'
  end

  it "should have a top-level if node" do
     @tree.sexp.should be_a_tree_like(s(:if, :_, :_, :_))
  end

  it "should have a node at 0:0 containing '75' as display text" do
    @tree[0].text.should == '75'
  end

  it "should have a literal node for 75 at 0:0 containing" do
    @tree[0].sexp.should be_a_tree_like(s(:lit, 75))
  end

  it "should have a node at 0:1 containing '0' as display text" do
    @tree[1].text.should == '0'
  end

  it "should have a literal node for 0 at 0:1" do
    @tree[1].sexp.should be_a_tree_like(s(:lit, 0))
  end

  it "should have a node at 0:2 containing '2' as display text" do
    @tree[2].text.should == '2'
  end

  it "should have a literal node for 2 at 0:2" do
    @tree[2].sexp.should be_a_tree_like(s(:lit, 2))
  end

end


describe "a literal array" do
  before(:each) do
    @the_array= RatCatcherStore.parse('[:one, :two, :three]')
  end

  it "should have three children" do
    @the_array.size.should == 3
  end

  it "should have :one for the first child" do
    @the_array[0].text.should == ":one"
  end

  it "should have :two for the second child" do
    @the_array[1].text.should == ":two"
  end

  it "should have :three for the third child" do
    @the_array[2].text.should == ":three"
  end
end


describe "the result of parsing an empty method argument list" do
  before :each do
    @tree= RatCatcherStore.from_sexp(s(:args))
  end

  it "should have no children" do
    @tree.size.should == 0
  end

  it "should have an empty argument names list" do
    @tree.argument_names.should have(0).arguments
  end
end


describe "the result of parsing a one-argument method argument list" do
  before :each do
    @tree= RatCatcherStore.from_sexp(s(:args, :arg_1))
  end
    
  it "should have one child" do
    @tree.argument_names.should have(1).argument
  end

  it "should have :arg_1 as the first argument" do
    @tree.argument_names[0].should == :arg_1
  end
end


describe "the result of parsing a two-argument method argument list" do
  before :each do
    @tree= RatCatcherStore.from_sexp(s(:args, :arg_1, :arg_2))
  end
    
  it "should have two arguments" do
    @tree.argument_names.should have(2).arguments
  end

  it "should have :arg_1 as the first argument" do
    @tree.argument_names[0].should == :arg_1
  end

  it "should have :arg_2 as the second argument" do
    @tree.argument_names[1].should == :arg_2
  end
end


describe "the result of parsing a splat method argument" do
  before :each do
    @tree= RatCatcherStore.from_sexp(s(:args, :"*splat_arg"))
  end
  
  it "should have one argument" do
    @tree.argument_names.should have(1).argument
  end

  it "should have :'*splat_arg' for the first argument" do
    @tree.argument_names[0].should == :"*splat_arg"
  end
end


describe "the result of parsing a block method argument" do
  before :each do
    @tree= RatCatcherStore.from_sexp(s(:args, :"&block_arg"))
  end
  
  it "should have one argument" do
    @tree.argument_names.should have(1).argument
  end

  it "should have :'&block_arg' for the first argument" do
    @tree.argument_names[0].should == :"&block_arg"
  end
end


describe "the result of parsing a method argument list that has default values" do
  before :each do
    @tree= RatCatcherStore.parse %q{
      def amethod(a_parm=3)
      end
    }
  end

  it "should have an init block" do
    @tree.init_block.sexp.should be_a_tree_like(
      s(:block, s(:lasgn, :a_parm, s(:lit, 3)))
    )
  end
end


describe "to_s method" do
  it "should return same text it parsed" do
    @tree= RatCatcherStore.parse %q{yield}
    s = @tree.to_s
    s == 'yield'
  end
end
                                     
                                     
describe "the yield statement" do
  before :each do
    @tree= RatCatcherStore.parse %q{yield}
  end
                             
  it "makes a sexp" do
    @tree.sexp.should be_a_tree_like(s(:yield))
  end
end


describe "failing on bogus sexps" do
  it "should fail" do
    lambda {RatCatcherStore.from_sexp(s(:totally_bogus))}.should raise_error
  end
end
