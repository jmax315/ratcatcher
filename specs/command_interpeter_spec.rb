require 'json'
require File.expand_path(File.dirname(__FILE__)) + '/../app/rat_catcher_app'

describe "invoking a method" do
  before :each do
    @rat_catcher= RatCatcherApp.new
  end

  it "should call the method specified" do
    @rat_catcher.should_receive(:do_something)
    encoded_call= ['do_something'].to_json
    @rat_catcher.invoke(encoded_call)
  end

  it "should call a different method" do
    @rat_catcher.should_receive(:do_something_else)
    encoded_call= ['do_something_else'].to_json
    @rat_catcher.invoke(encoded_call)
  end

  it "should pass an argument to the method" do
    @rat_catcher.should_receive(:do_something_else).with("an argument")
    encoded_call= ['do_something_else', 'an argument'].to_json
    @rat_catcher.invoke(encoded_call)
  end

  it "should receive a return value" do
    @rat_catcher.should_receive(:do_something_else).and_return("ferd")
    encoded_call= ['do_something_else'].to_json
    @rat_catcher.invoke(encoded_call).should == "ferd".to_json
  end
end
