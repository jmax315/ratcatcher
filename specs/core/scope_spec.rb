current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'


describe "an empty scope store" do
  it "should re-generate the supplied sexp" do
    sexp= s(:scope)
    parse_tree= RatCatcherStore.from_sexp(sexp)
    parse_tree.sexp.should == sexp
  end
end

describe "an scope store with one assignment in it" do
  it "should re-generate the supplied sexp" do
    sexp= s(:scope, s(:block, s(:lasgn, :a, s(:lit, 1))))
    parse_tree= RatCatcherStore.from_sexp(sexp)
    parse_tree.sexp.should == sexp
  end
end

describe "an scope store with two assignments in it" do
  it "should re-generate the supplied sexp" do
    sexp= s(:scope, s(:block, s(:lasgn, :a, s(:lit, 1)), s(:lasgn, :b, s(:lit, 2))))
    parse_tree= RatCatcherStore.from_sexp(sexp)
    parse_tree.sexp.should == sexp
  end
end

