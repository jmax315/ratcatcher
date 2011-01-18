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
end
