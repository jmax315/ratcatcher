current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/rat_catcher_store'

describe "specs we don't want to forget" do
  it "shouldn't depend on an instance variable name to use should_find_the_right_store"
  it "convert here-doc source code over to %q (makes emacs happier)"
  it "handle def String.method and similar"
  it "handle self. expressions"
end
