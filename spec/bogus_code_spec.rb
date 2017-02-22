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
    expect{RatCatcherStore.parse(@code)}.to raise_error(Parser::SyntaxError)
    end
    
  it "doesn't catch non parse exceptions" do
    expect(Parser::CurrentRuby).to receive(:parse).and_raise("not a parse")
    expect{RatCatcherStore.parse(@code)}.to raise_error("not a parse")
  end
end

describe "handling attempts to parse an empty string" do
    it "returns a valid cookie" do
      expect(RatCatcherStore.parse('')).not_to be_nil
    end

    it "returns the original (empty) code when asked" do
      store= RatCatcherStore.parse('')
      expect(store.source).to eq("")
    end
end

describe "handling attempts to parse nil" do
    it "raises an error" do
      expect{RatCatcherStore.parse(nil)}.to raise_error(RuntimeError)
    end
end
