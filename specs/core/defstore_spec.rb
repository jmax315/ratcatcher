describe 'method definition with no arguments and one statement' do
  before :each do
    @tree= RatCatcherStore.parse %q{
      def amethod
        5
      end
    }
  end

  it "has a node with text 'amethod'" do
    @tree.text.should == 'amethod'
  end

  it "has two children" do
    @tree.size.should == 2
  end

  it "has a first child which is an empty args node" do
    @tree[0].argument_names.should have(0).arguments
  end

  it "has a second child with one child" do
    @tree[1].size.should == 1
  end

  it "has an sexp" do
    @tree.sexp.should be_a_tree_like(s(:defn, :amethod, :_, :_))
  end

  it "has a second child which actually contains the right code" do
    @tree.children[1].sexp.should be_a_tree_like(s(:scope, s(:block, s(:lit, 5))))
  end

  it "has the statement text from the block body" do
    # TODO This is an ugly way to access the method contents
    @tree.children[1].children[0].children[0].text.should == "5"
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
     @tree.children[1].children[0].children[0].text.should == "puts"
   end

   it 'has second statement of p' do
     @tree.children[1].children[0].children[1].text.should == "p"
   end

end

describe 'method definition with arguments' do
  before :each do
    @tree= RatCatcherStore.parse %q{
      def amethod(a, b)
      end
    }
  end

  it "has a first child which is an args node with the right two arguments" do
    @tree[0].argument_names.should == [:a, :b]
  end
end
