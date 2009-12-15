current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'
require current_dir + '/path_spec_helpers'


describe "Searching inside a class definition" do
  before :each do
    src_code= %q{
      class AClass
        def a_method
          "ferd"
        end
      end
    }
    @store= RatCatcherStore.parse(src_code)
    @duplicate_store= RatCatcherStore.parse(src_code)
  end

  it "should parse the same twice" do
    @store.should == @duplicate_store
  end

  it "should contain an equivelant sexp after a find" do
    @store.find(nil)
    @store.should == @duplicate_store
  end

  it "should return nil if we pass a path that doesn't exist" do
    @store.find("Wombat").should == nil
  end

 it "should find the store itself if the path is nil" do
    @store.find(nil).should == @duplicate_store
 end

  it "should find the store itself if the path is empty" do
    @store.find("").should == @duplicate_store
  end

  it "should find the store itself if the path is '.'" do
    @store.find(".").should == @duplicate_store
  end

  it "should find the method definition" do
    pending "Start here"
    @store.find("a_method").should be_a_tree_like(s(:defn))
  end

  it "should find the method definition even with a redundant ./ in the path" do
    pending
    @store.find("./a_method").class.should ==  be_a_tree_like(s(:defn))
  end

  it "should find the method definition" do
    pending
    @store.find("a_method").text.should == be_a_tree_like(s(:defn))
  end
end




describe "When more than one class is present" do
  before :each do
    src_code= %q{
      class AClass
        def a_method
          "ferd"
        end
      end
      
      class AnotherClass
        def another_method
          "foo"
        end
      end
    }
    @store= RatCatcherStore.parse(src_code)
  end
    
  should_find_the_right_store 'AClass', 'ClassStore', 'AClass'
  should_find_the_right_store 'AnotherClass', 'ClassStore', 'AnotherClass'
end

describe "Searching for a class definition when there are several of them" do
  before :each do
    src_code= %q{
      class AClass
        def a_method
          "ferd"
        end
      end
      class BClass
        def b_method
          "foo"
        end
      end
    }
    @store= RatCatcherStore.parse(src_code)
  end

  it "should find the AClass class definition" do
    pending
    @store.find("AClass").class.should == ClassStore
  end

  it "should find the AClass class definition" do
    pending
    @store.find("AClass").text.should == "AClass"
  end

  it "should find the method definition" do
    pending
    @store.find("AClass/a_method").class.should == DefnStore
  end

  it "should find the method definition" do
    pending
    @store.find("AClass/a_method").text.should == "a_method"
  end

  it "should find the AClass class definition" do
    pending
    @store.find("AClass").class.should == ClassStore
  end

  it "should find the AClass class definition" do
    pending
    @store.find("AClass").text.should == "AClass"
  end

  it "should find the method definition" do
    pending
    @store.find("AClass/a_method").class.should == DefnStore
  end

  it "should find the method definition" do
    pending
    @store.find("AClass/a_method").text.should == "a_method"
  end

  it "should find the BClass class definition" do
    pending
    @store.find("BClass").class.should == ClassStore
  end

  it "should find the BClass class definition" do
    pending
    @store.find("BClass").text.should == "BClass"
  end

  it "should find the method definition" do
    pending
    @store.find("BClass/b_method").class.should == DefnStore
  end

  it "should find the method definition" do
    pending
    @store.find("BClass/b_method").text.should == "b_method"
  end
    
end


describe "Searching for a class definition when there are several of them" do
  before :each do
    src_code= %q{
      class BClass
        if wamo
          def b_method
            "foo"
          end
        else
          def c_method
            'c'
          end
        end
      end
    }
    @store= RatCatcherStore.parse(src_code)
  end

  it "should find c_method" do
    pending
    @store.find("c_method").class.should == DefnStore
  end

  it "should find c_method" do
    pending
    @store.find("c_method").text.should == "c_method"
  end

end
