current_dir= File.expand_path(File.dirname(__FILE__))

describe "handling attempts to parse bogus code" do
  before :each do
    @code = %q{
      class C
        x= 5
        def x
          "not 5"
        end
      }
    end
    
  it "should stay sane when handed this code" do
      pending
      lambda { RatCatcherStore.parse(@code) }.should raise_error(ParseError)
    end
    
  it "should not catch non parse exceptions" do
    pending
    RubyParser.should_receive(:new).and_raise("not a parse")
    lambda{RatCatcherStore.parse(@code)}.should raise_error("not a parse")
  end
end

describe "handling attempts to parse an empty string" do
    it "should return a valid cookie" do
      RatCatcherStore.parse('').should_not be_nil
    end

    it "should return the original (empty) code when asked" do
      pending
      RatCatcherStore.parse('').source.should == ""
    end
end

describe "handling attempts to parse nil" do
    it "should return a valid cookie" do
      pending
      lambda{RatCatcherStore.parse(nil)}.should raise_error(RuntimeError)
    end
end
