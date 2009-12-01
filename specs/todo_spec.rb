current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/rat_catcher_store'

describe "specs we don't want to forget" do
  it "shouldn't depend on an instance variable name to use should_find_the_right_store"
  it "handle the case where the class loader doesn't actually end up defining the class (e.g., an empty file)"
  it "add rename test for rescue block"
  it "add ensure block specs"
  it "add tests for arguments to rescue"
  it "add tests for begin/rescue/ensure/end"
  it "see about retry"
  it "see about dstr"
  it "see about evstr"
end
