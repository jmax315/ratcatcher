require_relative '../app/rat_catcher_store'

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
    
  it "stays sane when handed this code" do
      lambda { RatCatcherStore.parse(@code) }.should raise_error(Parser::SyntaxError)
    end
    
  it "doesn't catch non parse exceptions" do
    Parser::CurrentRuby.should_receive(:parse).and_raise("not a parse")
    lambda{RatCatcherStore.parse(@code)}.should raise_error("not a parse")
  end
end

describe "handling attempts to parse an empty string" do
    it "returns a valid cookie" do
      RatCatcherStore.parse('').should_not be_nil
    end

    it "returns the original (empty) code when asked" do
      store= RatCatcherStore.parse('')
      store.source.should == ""
    end
end

describe "handling attempts to parse nil" do
    it "raises an error" do
      lambda{RatCatcherStore.parse(nil)}.should raise_error(RuntimeError)
    end
end
