require_relative 'code_like_matcher'
require_relative '../app/rat_catcher_store'
require_relative '../app/rat_catcher_project'
require_relative '../app/rat_catcher_exception'

describe "renaming a project item" do
  before :each do
    @project= RatCatcherProject.new
    @project['an_item']= 'class C; end'
  end

  it "should do nothing when there isn't an item by that name" do
    pending
    @project.refactor(:rename_item, 'a_different_item', 'a_new_item')
    @project['an_item'].should be_code_like 'class C; end'
    @project.size.should == 1
  end

  it 'should change the item if there is one by that name' do
    pending
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
    pending
    @project.refactor(:rename_item, 'an_item', 'a_new_item')
    @project['another_item'].should be_code_like <<EOF
require File.dirname(__FILE__) + '/a_new_item'
class D
end
EOF
  end

  it "shouldn't change references to other files" do
    pending
    @project.refactor(:rename_item, 'a_different_item', 'a_new_item')
    @project['another_item'].should be_code_like("require 'an_item'; class D; end")
  end

  it "shouldn't change strings that aren't call arguments" do
    pending
    @project.refactor(:rename_item, 'another_item', 'a_new_item')
    @project['an_item'].should be_code_like 'class C; "another_item"; end'
  end

  it "shouldn't change strings that are arguments for non-require calls" do
    pending
    @project.refactor(:rename_item, 'an_item', 'a_new_item')
    @project['item_with_call'].should be_code_like('fubar("an_item")')
  end

  it 'should change all references to the file with .rb' do
    pending
    @project.refactor(:rename_item, 'an_item', 'a_new_item')
    @project['item_with_dot_rb'].should be_code_like("require File.dirname(__FILE__) + '/a_new_item'")
  end

  it 'should not change arbitrary strings within filenames' do
    pending
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
    pending
    @project.refactor(:rename_item, 'sub/something.rb', 'sub/something_else.rb')
    @project['first_item.rb'].should be_code_like <<-END
       require File.dirname(__FILE__) + '/sub/something_else.rb'
    END
  end

  it "should work when the new item has a different directory from the old" do
    pending
    @project.refactor(:rename_item, 'sub/something.rb', 'other/something.rb')
    @project['first_item.rb'].should be_code_like <<-END
       require File.dirname(__FILE__) + '/other/something.rb'
    END
  end

  it "should not rename things in subdirectories when not asked" do
    pending
    @project.refactor(:rename_item, 'something.rb', 'something_else.rb')
    @project['first_item.rb'].should be_code_like <<-END
       require 'sub/something.rb'
    END
  end
end


describe "renaming an item with a dynamic path component" do
  before :each do
    @project= RatCatcherProject.new
    @project['first_item.rb']= <<-END
       require 'sub/' + 'something.rb'
    END
  end

  it "should work when the new item has the same directory as the old" do
    pending
    @project.refactor(:rename_item, 'sub/something.rb', 'sub/something_else.rb')
    @project['first_item.rb'].should be_code_like <<-END
       require File.dirname(__FILE__) + '/sub/something_else.rb'
    END
  end
end

describe "renaming an item in the parent directory" do
  before :each do
    @project= RatCatcherProject.new
    @project['sub/first_item.rb']= <<-END
       require 'something.rb'
    END
  end

  it "should work when the new item has the same directory as the old" do
    pending
    @project.refactor(:rename_item, 'something.rb', 'something_else.rb')
    @project['sub/first_item.rb'].should be_code_like <<-END
       require File.dirname(__FILE__) + '/something_else.rb'
    END
  end
end

describe "renaming an item in child directory with a complex expression" do
  before :each do
    @project= RatCatcherProject.new
    @project['spec/first_item.rb']= <<-END
        require File.expand_path(File.dirname(__FILE__)) + '/sub/something.rb'
    END
  end

  it 'should not rename this' do
    pending
    @project.refactor(:rename_item, 'spec/sub/something.rb', 'spec/sub/something_else.rb')
    @project['spec/first_item.rb'].should be_code_like <<-END
        require File.expand_path(File.dirname(__FILE__)) + '/sub/something.rb'
    END
  end

  it 'should rename files in child directories' do
    pending
    @project.refactor(:rename_item, 'sub/something.rb', 'sub/something_else.rb')
    @project['spec/first_item.rb'].should be_code_like <<-END
        require File.dirname(__FILE__) + '/sub/something_else.rb'
    END
  end
end

describe "renaming other targets" do
  before :each do
    @project= RatCatcherProject.new
    @project['spec/first_item.rb']= <<-END
        require File.expand_path(File.dirname(__FILE__)) + '/../lib/app/something.rb'
    END
  end

  it "should not change expressions which don't refer to the target item" do
    pending
    @project.refactor(:rename_item, 'app/something.rb', 'app/something_else.rb')
    @project['spec/first_item.rb'].should be_code_like <<-END
        require File.expand_path(File.dirname(__FILE__)) + '/../lib/app/something.rb'
    END
  end
end

describe "error handling" do
  before :each do
    @project= RatCatcherProject.new
    @project['spec/first_item.rb']= <<-END
        here= File.expand_path(File.dirname(__FILE__))
        require  here + '/../lib/app/something.rb'
    END
  end

  it "should throw an exception by default if it can't handle a require" do
    pending
    lambda do
      @project.refactor(:rename_item, 'lib/app/something.rb', 'lib/app/something_else.rb')
    end.should raise_exception RatCatcherException
  end

  it "should throw an exception if ignore_complex_requires is specified and it can't handle a require" do
    pending
    lambda do
      @project.refactor(:rename_item,
                        'lib/app/something.rb',
                        'lib/app/something_else.rb',
                        :ignore_complex_requires => false)
    end.should raise_exception RatCatcherException
  end

  it "should silently do nothing if ignore_complex_exception is specified and it can't handle a require" do
    pending
    lambda do
      @project.refactor(:rename_item,
                        'lib/app/something.rb',
                        'lib/app/something_else.rb',
                        :ignore_complex_requires => true)
    end.should_not raise_exception Exception
  end

  it "should silently do nothing if ignore_complex_exception is specified as a bare keyword and it can't handle a require" do
    pending
    lambda do
      @project.refactor(:rename_item,
                        'lib/app/something.rb',
                        'lib/app/something_else.rb',
                        :ignore_complex_requires)
    end.should_not raise_exception Exception
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
