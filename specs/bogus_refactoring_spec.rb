current_dir= File.expand_path(File.dirname(__FILE__))

describe "RatCatcherStore" do
  before :each do
    @code = %q{
      class C
        x= 5
        def x
          "not 5"
        end
      end
      }
    end
    
  it "should throw an exception when asked to do an unknown refactoring" do
      parsed_code= RatCatcherStore.parse(@code)
    lambda { parsed_code.apply(:bogus_refactoring) }.should raise_error("unknown refactoring: bogus_refactoring")
    end
    
  # it "should not catch non parse exceptions" do
  #   RubyParser.should_receive(:new).and_raise("not a parse")
  #   lambda{RatCatcherStore.parse(@code)}.should raise_error("not a parse")
  # end
end
