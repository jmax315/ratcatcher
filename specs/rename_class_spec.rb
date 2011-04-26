cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'


describe 'when the buffer is empty' do
  it 'should do nothing when asked to rename a class' do
    @tree= RatCatcherStore.parse '', "empty_string"
    @tree.refactor(:rename_class, 'OldClass', 'NewClass')
    @tree.sexp.should be_nil
  end
end

describe 'when the class is not defined in the file' do
  it 'should not change the file' do
    @tree= RatCatcherStore.parse 'class AnotherClass; end', "junk"
    @tree.refactor(:rename_class, 'OldClass', 'NewClass')
    @tree.source.should be_code_like "class AnotherClass\nend"
  end
end

describe 'when the class is defined in the file' do
  it 'should rename the class' do
    @tree= RatCatcherStore.parse 'class OldClass; end', "junk"
    @tree.refactor(:rename_class, 'OldClass', 'NewClass')
    @tree.source.should be_code_like "class NewClass\nend"
  end
end

describe 'renaming a reference to a class' do
  it 'should rename the reference' do
    @tree= RatCatcherStore.parse(<<-CODE, "junk")
       class Foo
       end
       Foo.new
     CODE

    @tree.refactor(:rename_class, 'Foo', 'Bar')
    @tree.source.should be_code_like "class Bar\nend\nBar.new\n"
  end
end


describe 'renaming a parent class' do
  it 'should rename the reference' do
    @tree= RatCatcherStore.parse( <<-CODE, "junk")
       class ChildClass < ParentClass
       end
    CODE

    @tree.refactor(:rename_class, 'ParentClass', 'StepParentClass')
    @tree.source.should be_code_like "class ChildClass < StepParentClass\nend"
  end
end

describe 'renaming an inner class' do
  it "should rename the inner class" do
    @tree= RatCatcherStore.parse "class Outer; Inner.new; end", "junk"
    @tree.refactor(:rename_class, 'Inner', 'Space')
    @tree.source.should be_code_like "class Outer\n  Space.new\nend"
  end
end
