current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/tree_like_matcher'

describe "Searching inside a class definition" do
  before :each do
    @helper= TreeLikeMatcher.new("ferd")
    @helper.matches?("foo")
  end

  it "should convert to the correct string" do
    @helper.to_s.should == "#<TreeLikeMatcher @expected= \"ferd\">"
  end

  it "should have the correct failure message" do
    @helper.failure_message.should == "expected \"foo\" to be a tree like \"ferd\""
  end

  it "should have the correct negative failure message" do
    @helper.negative_failure_message.should == "expected \"foo\" not to be a tree like \"ferd\""
  end
end
