cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'


describe 'when the buffer is empty' do
  it 'should do nothing when asked to rename a class' do
    @tree= RatCatcherStore.parse ''
    @tree.refactor(:rename_class, 'OldClass', 'NewClass')
    @tree.sexp.should be_nil
  end
end

describe 'when the class is not defined in the file' do
  it 'should not change the file' do
    @tree= RatCatcherStore.parse 'class AnotherClass; end'
    @tree.refactor(:rename_class, 'OldClass', 'NewClass')
    @tree.source.should == "class AnotherClass\nend"
  end
end

describe 'when the class is defined in the file' do
  it 'should rename the class' do
    @tree= RatCatcherStore.parse 'class OldClass; end'
    @tree.refactor(:rename_class, 'OldClass', 'NewClass')
    @tree.source.should == "class NewClass\nend"
  end
end

describe 'renaming a reference to a class' do
  it 'should rename the reference' do
    @tree= RatCatcherStore.parse <<-CODE
       class Foo
       end
       Foo.new
    CODE

    @tree.refactor(:rename_class, 'Foo', 'Bar')
    @tree.source.should == "class Bar\nend\nBar.new\n"
  end
end


describe 'renaming a parent class' do
  it 'should rename the reference' do
    @tree= RatCatcherStore.parse <<-CODE
       class ChildClass < ParentClass
       end
    CODE

    @tree.refactor(:rename_class, 'ParentClass', 'StepParentClass')
    @tree.source.should == "class ChildClass < StepParentClass\nend"
  end
end

describe 'renaming an inner class' do
  it "should rename the inner class"
end
