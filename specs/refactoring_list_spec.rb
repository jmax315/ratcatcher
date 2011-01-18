describe "RatCatcherApp#refactorings" do
  it "should return a list including the rename_variable refactoring" do
    RatCatcherApp.refactorings.should include "rename_variable"
  end

  it "should return a list including the rename_method refactoring" do
    RatCatcherApp.refactorings.should include "rename_method"
  end
end
