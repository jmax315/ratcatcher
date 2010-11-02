require File.expand_path(File.dirname(__FILE__)) + '/../app/rat_catcher_app'

describe "encoding the Rat Catcher Protocol" do
  before :each do
    @the_app= RatCatcherApp.new(nil, nil)
  end

  it "should echo one argument" do
    @the_app.echo("Hello").should == "Hello"
  end
end

