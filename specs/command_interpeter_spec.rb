require File.expand_path(File.dirname(__FILE__)) + '/../app/rat_catcher_app'

describe "encoding the Rat Catcher Protocol" do
  it "should include line count followed by JSON encoding" do
    RatCatcherApp.to_rcp("a_string").should == "1\n\"a_string\""
  end

  it "should encode multi-line strings" do
    RatCatcherApp.to_rcp("line 1\nline2").should == "1\n\"line 1\\nline2\""
  end
end

describe "invoking a method" do
  before :each do
    @rat_catcher= RatCatcherApp.new
  end

  it "should call the method specified" do
    @rat_catcher.should_receive(:do_something)
    encoded_call= ['do_something'].to_rcp
    @rat_catcher.invoke(encoded_call)
  end

  it "should call a different method" do
    @rat_catcher.should_receive(:do_something_else)
    encoded_call= ['do_something_else'].to_rcp
    @rat_catcher.invoke(encoded_call)
  end

  it "should pass an argument to the method" do
    @rat_catcher.should_receive(:do_something_else).with("an argument")
    encoded_call= ['do_something_else', 'an argument'].to_rcp
    @rat_catcher.invoke(encoded_call)
  end

  it "should receive a return value" do
    @rat_catcher.should_receive(:do_something_else).and_return("ferd")
    encoded_call= ['do_something_else'].to_rcp
    @rat_catcher.invoke(encoded_call).should == "ferd".to_rcp
  end

  it "should receive a return value with a newline" do
    @rat_catcher.should_receive(:the_method).and_return("line 1\nline2\n")
    encoded_call= ['the_method'].to_rcp
    @rat_catcher.invoke(encoded_call).should == "line 1\nline2\n".to_rcp
  end
end
