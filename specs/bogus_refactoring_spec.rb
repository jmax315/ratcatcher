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
    lambda { parsed_code.refactor(:bogus_refactoring) }.should raise_exception(RatCatcherException, "unknown refactoring: bogus_refactoring")
    end
end
