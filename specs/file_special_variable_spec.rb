current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/rat_catcher_store'

describe "Parsing a __FILE__ token" do
  it "should return a reference to a variable named __FILE__" do
    @store= RatCatcherStore.parse '__FILE__'
    @store.source.should be_code_like '__FILE__'
  end
end
