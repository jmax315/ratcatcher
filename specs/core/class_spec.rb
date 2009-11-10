current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'


describe 'parsing and then re-generating a class' do
  before :each do
    @src= <<-EOF
        class AClass
          def a_method
            "Oh no!"
          end
        end
        EOF
    @parse_tree= RatCatcherStore.parse(@src)
  end

  it 'should give the correct sexp' do
    @parse_tree.sexp.should == s(:class, :AClass, nil, s(:scope, s(:defn, :a_method, s(:args), s(:scope, s(:block, s(:str, "Oh no!"))))))
  end

  it 'should give back the original code' do
    @parse_tree.to_ruby.should be_code_like(@src)
  end
end


describe 'a class definition with no superclass' do
  before :each do
    @tree= RatCatcherStore.parse %q{
        class MyClass
        end
      }
    end
    
    it 'has a node with the correct text' do
      @tree.text.should == 'MyClass'
    end
    
    it 'has two children' do
      @tree.children.size.should == 2
    end

    it 'has no explicit superclass' do
      @tree.superclass.should be_instance_of(NilStore)
    end

    it 'has a scope' do
      @tree.body.should be_instance_of(ScopeStore)
    end

    it "has a sexp of the correct form" do
      @tree.sexp.should be_a_tree_like(
            s(:class, :MyClass, nil, s(:scope))
            )
    end
end


describe 'a class definition with a superclass' do
  before :each do
      @tree= RatCatcherStore.parse %q{
        class MyClass < Ferd
        end
      }
    end
    
    it 'has a node with the correct text' do
      @tree.text.should == 'MyClass'
    end
    
    it 'has two children' do
      @tree.children.size.should == 2
    end

    it 'has a superclass"' do
      @tree.superclass.should be_instance_of(ConstStore)
    end

    it 'has a superclass named "Ferd"' do
      @tree.superclass.text.should == "Ferd"
    end

    it 'has a scope' do
      @tree.body.should be_instance_of(ScopeStore)
    end

    it "has a sexp of the correct form" do
      @tree.sexp.should be_a_tree_like(
            s(:class, :MyClass, s(:const, :Ferd), s(:scope))
            )
    end
end