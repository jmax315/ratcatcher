require File.expand_path(File.dirname(__FILE__)) + '/../app/rat_catcher_app'

describe "creating a new ratcatcher object from source code" do
  before :each do
    app= RatCatcherApp.new(nil, nil)
    @src_code= "print \"Ruby says 'Hi there'.\"\n"
    @item= app.create_project_item(@src_code).should_not be_nil
  end

  it "should accept source code" do
    @item.should_not be_nil
  end

  it "should contain the source code" do
    pending
    @item.source.should == @src_code
  end
  
end
