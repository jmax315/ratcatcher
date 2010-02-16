cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'
require cur_dir + '/../app/tree_like_matcher'


describe 'variable assignment' do
  def variable_should_be(name)
    @tree.sexp.should be_a_tree_like(s(:lasgn, name.to_sym, :_))
    @tree.to_ruby.should == "#{name} = 5"
  end

  before :each do
    @tree= RatCatcherStore.parse 'a_variable = 5'
  end

  it 'should rename a_variable' do
    @tree.apply(:rename_variable, 'a_variable', 'new_name')
    variable_should_be('new_name')
  end

  it 'should not rename the_wrong_variable' do
    @tree.apply(:rename_variable, 'the_wrong_variable', 'new_name')
    variable_should_be('a_variable')
  end
end

describe 'variable passed to a method' do
  before :each do
    @tree = RatCatcherStore.parse('the_stop=11; thing.go_method(the_stop)')
    @tree.apply(:rename_variable, 'the_stop','the_go')
  end
  
  it 'variable should change' do
    @tree.to_ruby.should == "the_go = 11\nthing.go_method(the_go)\n"
  end
end

describe 'instance variable' do
  before :each do
    @tree = RatCatcherStore.parse('@the_stop = 1')
    @tree.apply(:rename_variable, '@the_stop','@the_go')
  end
  
  it 'variable should change' do
    @tree.to_ruby.should == "@the_go = 1"
  end
end

describe 'variable assignment using variable reference' do
  before :each do
    @tree= RatCatcherStore.parse 'a_variable = a_variable + 5'
    @tree.apply(:rename_variable, 'a_variable', 'new_name')
  end

  it 'should rename a_variable in the tree on the left of the =' do
    @tree.sexp.should be_a_tree_like(s(:lasgn, :new_name, :_))
  end

  it 'should rename a_variable in the tree on the right side of the =' do
    @tree.sexp.should be_a_tree_like(s(:_, :_, s(:_, s(:lvar, :new_name), :+, :_)))
  end

  it 'should generate Ruby code with the new variable name' do
    @tree.to_ruby.should == "new_name = (new_name + 5)"
  end
end

describe "handling a variable name introduced as a method parameter" do
  before :each do
    src_code= 'def a_method(a_param, a_different_param); puts a_param; end'
    @store= RatCatcherStore.parse(src_code)
    @store.apply(:rename_variable, 'a_param', 'new_name')
  end

  it 'should rename the variable in the parameter list and the code body' do
    @store.to_ruby.should == "def a_method(new_name, a_different_param)\n  puts(new_name)\nend"
  end
end


describe "handling a variable name referenced as a method parameter" do
  it 'should rename the variable in the parameter list' do
    src_code= 'v= 1; a_method(v)'
    store= RatCatcherStore.parse(src_code)
    store.apply(:rename_variable, 'v', 'new_v')
    store.to_ruby.should == "new_v = 1\na_method(new_v)\n"
  end
end


describe 'Method within a class' do
  before :each do
    src_code= %q{
class MyClass
  def my_first_method(ferd)
    ferd= 'foo'
  end
end
    }
    @store= RatCatcherStore.parse(src_code)
  end

  it "should be able to rename on the method" do
    method_store= @store.find('MyClass/my_first_method')
    method_store.apply(:rename_variable, 'ferd', 'frobazz')
    @store.to_ruby.should == %q{class MyClass
  def my_first_method(frobazz)
    frobazz = "foo"
  end
end}
  end
end


describe 'Two methods with identicaly named parameters' do
  before :each do
    src_code= %q{
      class MyClass
        def my_first_method(ferd)
          ferd= 'foo'
        end

        def my_other_method(ferd)
          ferd= 'not foo'
        end
      end
    }
    @store= RatCatcherStore.parse(src_code)
  end

  it "should be able to rename one method's parameter without affecting the other's" do
    method_store= @store.find('MyClass/my_first_method')
    method_store.apply(:rename_variable, 'ferd', 'frobazz')
    method_store.to_ruby.should == "def my_first_method(frobazz)\n  frobazz = \"foo\"\nend"
    other_method_store= @store.find('MyClass/my_other_method')
    other_method_store.to_ruby.should == "def my_other_method(ferd)\n  ferd = \"not foo\"\nend"
  end
end

