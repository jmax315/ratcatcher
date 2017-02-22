require_relative '../app/refactoring'

describe "Refactoring::list" do
  it "should return a list including the rename_variable refactoring" do
    expect(Refactoring.list).to include("rename_variable")
  end

  it "should return a list including the rename_method refactoring" do
    expect(Refactoring.list).to include("rename_method")
  end

  it "should find the correct number of refactorings" do
    expect(Refactoring.list.length).to eq(Dir.glob('app/refactorings/*.rb').length)
  end

  it "should find a different set of files" do
    expect(Dir).to receive(:glob).and_return(["../app/fake_directory/foo.rb"])
    expect(Refactoring.list).to eq(["foo"])
  end

  Dir.glob('app/refactorings/*.rb').each do |file|
    refactoring_name= File.basename(file, '.rb')
    it "should find the #{refactoring_name} refactoring" do
      refactoring= Refactoring.new(refactoring_name)
      expect(refactoring.get_refactoring_class.name).to eq(refactoring.class_name)
    end
  end
end
