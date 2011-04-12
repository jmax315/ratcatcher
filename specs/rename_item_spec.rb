require File.expand_path(File.dirname(__FILE__)) + '/../app/refactorings/rename_item.rb'

describe "determining whether two paths refer to the same file" do

  it "should return true for identical filenames" do
    RenameItem.new("old", "new", "/source.rb").is_same_file("referenced_file.rb", "/referenced_file.rb").should be_true
  end

  it "should return false for different filenames" do
    RenameItem.new("old", "new", "/source.rb").is_same_file("referenced_file.rb", "/not_the_referenced_file.rb").should be_false
  end

  it "should return true for equivalent filenames" do
    RenameItem.new("old", "new", "/source.rb").is_same_file("./referenced_file.rb", "/referenced_file.rb").should be_true
  end

  it "should return true for pathologically equivalent filenames" do
    RenameItem.new("old", "new", "/sub/source.rb").is_same_file("./../sub/../sub/referenced_file.rb", "/sub/referenced_file.rb").should be_true
  end

  it "should return true when refering to a file in a sub-directory" do
    RenameItem.new("old", "new", "/foo.rb").is_same_file("sub/bar.rb", "/sub/bar.rb").should be_true
  end

  it "should return true when refering to a file in a parent directory" do
    RenameItem.new("old", "new", "/sub/source.rb").is_same_file("../bar.rb", "/bar.rb").should be_true
  end

  it "should return true when refering to a file in a sibling directory" do
    RenameItem.new("old", "new", "/sub1/source.rb").is_same_file("../sub2/bar.rb", "/sub2/bar.rb").should be_true
  end

  it "should return true when refering to an absolute path" do
    RenameItem.new("old", "new", "/sub1/source.rb").is_same_file("/sub2/bar.rb", "/sub2/bar.rb").should be_true
  end

end
