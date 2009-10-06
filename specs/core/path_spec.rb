current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'
require current_dir + '/path_spec_helpers'


describe "Searching inside a class definition" do
  before :each do
    src_code= <<-SRC_CODE
      class AClass
        def a_method
          "ferd"
        end
      end
      SRC_CODE
      @store= RatCatcherStore.parse(src_code)
  end

  it "should find the class definition" do
    @store.find(".").should == @store
  end

  it "should find the method definition" do
      @store.find("a_method").class.should == DefnStore
  end

  it "should find the method definition" do
      @store.find("a_method").text.should == "a_method"
  end
end




describe "When more than one class is present" do
    before :each do
    src_code= <<-SRC_CODE
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
      SRC_CODE
      @store= RatCatcherStore.parse(src_code)
    end
    
    should_find_the_right_store 'AClass', 'ClassStore', 'AClass'
    should_find_the_right_store 'AnotherClass', 'ClassStore', 'AnotherClass'
end

describe "Searching for a class definition when there are several of them" do
  before :each do
    src_code= <<-SRC_CODE
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
      SRC_CODE
      @store= RatCatcherStore.parse(src_code)
  end

  it "should do something sane when handed a '.'" do
    pending
    @store.find(".").text.should == @store
  end

  it "should find the AClass class definition" do
      @store.find("AClass").class.should == ClassStore
  end

  it "should find the AClass class definition" do
      @store.find("AClass").text.should == "AClass"
  end

  it "should find the method definition" do
      @store.find("AClass/a_method").class.should == DefnStore
  end

  it "should find the method definition" do
      @store.find("AClass/a_method").text.should == "a_method"
  end
  it "should find the AClass class definition" do
      @store.find("AClass").class.should == ClassStore
  end

  it "should find the AClass class definition" do
      @store.find("AClass").text.should == "AClass"
  end

  it "should find the method definition" do
      @store.find("AClass/a_method").class.should == DefnStore
  end

  it "should find the method definition" do
      @store.find("AClass/a_method").text.should == "a_method"
  end

  it "should find the BClass class definition" do
      @store.find("BClass").class.should == ClassStore
  end

  it "should find the BClass class definition" do
      @store.find("BClass").text.should == "BClass"
  end

  it "should find the method definition" do
      @store.find("BClass/b_method").class.should == DefnStore
  end

  it "should find the method definition" do
      @store.find("BClass/b_method").text.should == "b_method"
  end
    
end


describe "Searching for a class definition when there are several of them" do
  before :each do
    src_code= <<-SRC_CODE
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
      SRC_CODE
    @store= RatCatcherStore.parse(src_code)
  end

  it "should find c_method" do
    @store.find("c_method").class.should == DefnStore
  end

  it "should find c_method" do
    @store.find("c_method").text.should == "c_method"
  end

end
