cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'


describe "renaming a project item" do
  before :each do
    @project= RatCatcherProject.new
    @project['an_item']= 'class C; end'
  end

  it "should do nothing when there isn't an item by that name" do
    @project.refactor(:rename_item, 'a_different_item', 'a_new_item')
    @project['an_item'].should be_code_like 'class C; end'
    @project.size.should == 1
  end

  it 'should change the item if there is one by that name' do
    @project.refactor(:rename_item, 'an_item', 'a_new_item')
    @project['a_new_item'].should be_code_like 'class C; end'
    @project.size.should == 1
  end
end

describe "renaming a project item (another case)" do
  before :each do
    @project= RatCatcherProject.new
    @project['an_item']= 'class C; "another_item"; end'
    @project['another_item']= "require 'an_item'; class D; end"
    @project['item_with_call']= 'fubar("an_item")'
    @project['item_with_dot_rb']= "require 'an_item.rb'"
  end

  it 'should change all references to the file' do
    @project.refactor(:rename_item, 'an_item', 'a_new_item')
    @project['another_item'].should be_code_like("require 'a_new_item'; class D; end")
  end

  it "shouldn't change references to other files" do
    @project.refactor(:rename_item, 'a_different_item', 'a_new_item')
    @project['another_item'].should be_code_like("require 'an_item'; class D; end")
  end

  it "shouldn't change strings that aren't call arguments" do
    @project.refactor(:rename_item, 'another_item', 'a_new_item')
    @project['an_item'].should be_code_like 'class C; "another_item"; end'
  end

  it "shouldn't change strings that are arguments for non-require calls" do
    @project.refactor(:rename_item, 'an_item', 'a_new_item')
    @project['item_with_call'].should be_code_like('fubar("an_item")')
  end

  it 'should change all references to the file' do
    @project.refactor(:rename_item, 'an_item', 'a_new_item')
    @project['item_with_dot_rb'].should be_code_like("require 'a_new_item.rb'")
  end

  it 'should not change arbitrary strings within filenames' do
    @project.refactor(:rename_item, 'item', 'a_new_item')
    @project['item_with_dot_rb'].should be_code_like("require 'an_item.rb'")
  end

  it "should change all references to the file even if it's a path" do
    @project.refactor(:rename_item, 'item', 'a_new_item')
    @project['item_with_dot_rb'].should be_code_like("require 'an_item.rb'")
  end

end


describe "renaming an item with a path component" do
  before :each do
    @project= RatCatcherProject.new
    @project['first_item.rb']= <<-END
       require 'sub/something.rb'
    END
  end

  it "should work when the new item has the same directory as the old" do
    @project.refactor(:rename_item, 'sub/something.rb', 'sub/something_else.rb')
    @project['first_item.rb'].should be_code_like <<-END
       require 'sub/something_else.rb'
    END
  end

  it "should work when the new item has a different directory from the old" do
    @project.refactor(:rename_item, 'sub/something.rb', 'other/something.rb')
    @project['first_item.rb'].should be_code_like <<-END
       require 'other/something.rb'
    END
  end
end

describe "renaming an item with a complex expression" do
  before :each do
    @project= RatCatcherProject.new
    @project['spec/first_item.rb']= <<-END
        require File.expand_path(File.dirname(__FILE__)) + '/../app/something.rb'
    END
  end

  it "should work" do
    @project.refactor(:rename_item, 'app/something.rb', 'app/something_else.rb')
    @project['spec/first_item.rb'].should be_code_like <<-END
        require File.expand_path(File.dirname(__FILE__)) + '/../app/something_else.rb'
    END
  end
end

#   before :each do
#     @project= RatCatcherProject.new
#     @project['item']= "'foo'"
#     @project['app/more_code']= "require '../item'"
#     @project['app/funny_code']= "require '.././item'"
#   end

#   it "should rename the item" do
#     pending
#     @project.refactor(:rename_item, 'item', 'different_item')
#     @project['app/more_code'].should be_code_like "require '../different_item'"
#   end

#   it "should not rename the item if the path isn't specified" do
#     pending
#     @project.refactor(:rename_item, '../item', '../different_item')
#     @project['app/more_code'].should be_code_like "require '../item'"
#   end

#   it "should handle referencing the same item via different paths" do
#     pending
#     @project.refactor(:rename_item, '../item', '../another_item')
#     @project['funny_code'].should be_code_like "require '../another_item'"
#   end
# end

# describe "normalizing a file path relative to foo" do
#   it "should not change an already normalized path"
#   it "should not change a path that's outside the project"
# end
