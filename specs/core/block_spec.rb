current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'

describe "BlockStore" do
  it "should generate an empty sexp for an empty block" do
    parse_tree= RatCatcherStore.parse("begin; end")
    parse_tree.should == s(:nil)
  end

  it "should generate a simple expression for a single-expression block" do
    parse_tree= RatCatcherStore.parse("begin; a= 1; end")
    parse_tree.sexp.should == s(:lasgn, :a, s(:lit, 1))
  end

  it "should generate a block for a two-expression block" do
    parse_tree= RatCatcherStore.parse("begin; a= 1; b= 2; end")
    parse_tree.sexp.should == s(:block, s(:lasgn, :a, s(:lit, 1)), s(:lasgn, :b, s(:lit, 2)))
  end
end
