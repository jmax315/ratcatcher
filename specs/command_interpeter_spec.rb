require File.expand_path(File.dirname(__FILE__)) + '/../app/rat_catcher_app'

describe "encoding the Rat Catcher Protocol" do
  it "should include line count followed by JSON encoding" do
    RatCatcherApp.to_rcp("a_string").should == "1\n\"a_string\""
  end

  it "should encode multi-line strings" do
    RatCatcherApp.to_rcp("line 1\nline2").should == "1\n\"line 1\\nline2\""
  end
end

describe "decoding the Rat Catcher Protocol" do
  it "should handle 1 line JSON" do
    encoded_call= "1\n[\"do_something_else\",\"an argument\"]\n"
    RatCatcherApp.from_rcp(encoded_call).should == ["do_something_else", "an argument"]
  end

  it "should handle two-line JSON" do
    encoded_call= "2\n[\"do_something_else\",\n\"an argument\"]\n"
    RatCatcherApp.from_rcp(encoded_call).should == ["do_something_else", "an argument"]
  end

  it "should handle multi-line JSON" do
    encoded_call= "4\n[\n  \"do_something_else\",\n  \"an argument\"\n]\n"
    RatCatcherApp.from_rcp(encoded_call).should == ["do_something_else", "an argument"]
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

  it "should handle multi-line calls" do
    @rat_catcher.should_receive(:do_something_else).with("an argument")
    encoded_call= "4\n[\n  \"do_something_else\",\n  \"an argument\"\n]\n"
    @rat_catcher.invoke(encoded_call)
  end

  it "should receive an encoded return value" do
    @rat_catcher.should_receive(:do_something_else).and_return("ferd")
    encoded_call= ['do_something_else'].to_rcp
    @rat_catcher.invoke(encoded_call).should == "ferd".to_rcp
  end

  it "should receive an encoded return value containing a newline" do
    @rat_catcher.should_receive(:the_method).and_return("line 1\nline2\n")
    encoded_call= ['the_method'].to_rcp
    @rat_catcher.invoke(encoded_call).should == "line 1\nline2\n".to_rcp
  end
end

describe "handling an input stream" do
  before :each do
    @rat_catcher= RatCatcherApp.new
  end

  it "should call capture a single-line command" do
    encoded_call= "1\n[\"do_something_else\",\"an argument\"]\n"
    input_stream= StringIO.new(encoded_call)
    @rat_catcher.read_next(input_stream).should == "[\"do_something_else\",\"an argument\"]\n"
  end

  it "should call capture a multi-line command" do
    encoded_call= "4\n[\n  \"do_something_else\",\n  \"an argument\"\n]\n"
    input_stream= StringIO.new(encoded_call)
    @rat_catcher.read_next(input_stream).should == "[\n  \"do_something_else\",\n  \"an argument\"\n]\n"
  end
end
