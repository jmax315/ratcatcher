describe "RatCatcherApp#refactorings" do
  it "should return a list including the rename_variable refactoring" do
    Refactoring.list.should include "rename_variable"
  end

  it "should return a list including the rename_method refactoring" do
    Refactoring.list.should include "rename_method"
  end

  it "should find the correct number of refactorings" do
    Refactoring.list.length().should == Dir.glob('app/refactorings/*.rb').length()
  end

  it "should find a different set of files" do
    Dir.should_receive(:glob).and_return(["../app/fake_directory/foo.rb"])
    Refactoring.list.should == ["foo"]
  end

end
