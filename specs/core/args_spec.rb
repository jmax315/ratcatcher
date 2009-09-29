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

  it "should re-generate the correct sexp" do
    @tree.sexp.should be_a_tree_like(s(:args))
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

  it "should re-generate the correct sexp" do
    @tree.sexp.should be_a_tree_like(s(:args, :arg_1))
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

  it "should re-generate the correct sexp" do
    @tree.sexp.should be_a_tree_like(s(:args, :arg_1, :arg_2))
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

  it "should re-generate the correct sexp" do
    @tree.sexp.should be_a_tree_like(s(:args, :"*splat_arg"))
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

  it "should re-generate the correct sexp" do
    @tree.sexp.should be_a_tree_like(s(:args, :"&block_arg"))
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
