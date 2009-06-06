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
    @tree.text.should == '"ferd"'
  end

  it "should have one node containing s(:str, 'ferd') as its sexp" do
    @tree.sexp.should be_a_tree_like(s(:str, "ferd"))
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

describe 'method definition with one statement' do
  before :each do
    @tree= RatCatcherStore.parse %q{
      def amethod
        5
      end
    }
  end

  it "has a node" do
    @tree.text.should == 'def amethod'
  end

  it "has an sexp" do
    @tree.sexp.should be_a_tree_like(s(:defn, :amethod, :_, :_))
  end

  it "has the statement text" do
    @tree[0].text.should == "5"
  end

  it "has the statement sexp" do
    @tree[0].sexp.should be_a_tree_like(s(:lit, 5))
  end

end

describe 'method definition with two statements' do
  before :each do
    @tree= RatCatcherStore.parse %q{
      def amethod
        puts "one"
        p "two"
      end
    }
  end

  it "has first statement of puts" do
    @tree[0].text.should == "puts"
  end

  it 'has second statement of p' do
    @tree[1].text.should == "p"
  end

  it "has first statement sexp" do
    @tree[0].sexp.should be_a_tree_like(s(:call, nil, :puts, :_))
  end

  it "has second statement sexp" do
    @tree[1].sexp.should be_a_tree_like(s(:call, nil, :p, :_))
  end

end

describe 'method definition with arguments' do
  before :each do
    @tree= RatCatcherStore.parse %q{
      def amethod(a, b, *c, &d)
        77
      end
    }
  end

  it "has an sexp" do
    @tree.sexp.should be_a_tree_like(
      s(:defn, :amethod, s(:args, :a, :b, :'*c', :'&d'), :_))
  end

end

describe 'yield statement' do
  before :each do
    @tree= RatCatcherStore.parse %q{yield}
  end

  it "makes a sexp" do
    @tree.sexp.should be_a_tree_like(s(:yield))
  end
end

