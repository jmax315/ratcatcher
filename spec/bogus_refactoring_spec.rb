require_relative '../app/rat_catcher_store'
require_relative '../app/rat_catcher_exception'

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
      expect{ parsed_code.refactor(:bogus_refactoring) }.to raise_exception(RatCatcherException, "unknown refactoring: bogus_refactoring")
    end
end
