require File.expand_path(File.dirname(__FILE__)) + '/../app/rat_catcher_app'

describe "creating a new ratcatcher object from source code" do
  before :each do
    @app= RatCatcherApp.new

    @src_code= "print(\"Ruby says 'Hi there'.\")"
    @cookie= @app.create_project_item(@src_code)

    @different_src_code= "print(\"2+2=4.\")"
    @different_cookie= @app.create_project_item(@different_src_code)
  end

  it "should accept source code" do
    @cookie.should_not be_nil
  end

  it "should contain the source code" do
    pending
    @app.code_from_cookie(@cookie).should be_code_like @src_code
  end
  
  it "should accept different source code" do
    @different_cookie.should_not be_nil
  end
  
  it "should contain the different source code" do
    pending
    @app.code_from_cookie(@different_cookie).should be_code_like @different_src_code
  end
end


describe "creating a new ratcatcher object from an empty string" do
  before :each do
    @app= RatCatcherApp.new

    @src_code= ""
    @cookie= @app.create_project_item(@src_code)
  end

  it "should accept source code" do
    @cookie.should_not be_nil
  end

  it "should contain the source code" do
    pending
    @app.code_from_cookie(@cookie).should be_code_like @src_code
  end
end
