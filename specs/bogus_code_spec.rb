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
    RatCatcherStore.parse(@code).should be_nil
  end
    
  it "should not catch non parse exceptions" do
    RubyParser.should_receive(:new).and_raise("not a parse")
    lambda{RatCatcherStore.parse(@code)}.should raise_error("not a parse")
  end
end
