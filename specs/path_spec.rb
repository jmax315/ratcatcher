current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/rat_catcher_store'
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

  it "should find the class definition" do
    find_sexp("AClass").should be_a_tree_like(s(:class, :AClass, :*))
  end

  it "should find the method definition" do
    find_sexp("a_method").should be_a_tree_like(s(:defn,
                                                    :a_method,
                                                    :_,
                                                    :_))
  end

  it "should find the method definition even with a redundant ./ in the path" do
    find_sexp("./a_method").should be_a_tree_like(s(:defn,
                                                      :a_method,
                                                      :_,
                                                      :_))
  end

  def find_sexp(path)
    temp= @store.find(path)
    if temp
      temp.sexp
    else
      nil
    end
  end
end




describe "A ProjectItem with two classes" do
  before :each do
    src_code= %q{
      class AClass
        def a_method
          "ferd"
        end
        def c_method
          "fubar"
        end
      end
      class BClass
        def b_method
          "foo"
        end
        def c_method
          "fooseball"
        end
      end
    }
    @store= RatCatcherStore.parse(src_code)
  end

  it "should be able to find the first class" do
    @store.find("AClass").sexp.should be_a_tree_like(s(:class, :AClass, :*))
  end

  it "should be able to find the first method in the first class" do
    @store.find("AClass/a_method").sexp.should be_a_tree_like(s(:defn, :a_method, :*))
  end

  it "should be able to find the duplicately named method in the first class" do
    @store.find("AClass/c_method").sexp.should be_a_tree_like(s(:defn, :c_method, :*))
  end

  it "should be able to find the second class" do
    @store.find("BClass").sexp.should be_a_tree_like(s(:class, :BClass, :*))
  end

  it "should be able to find the first method in the second class" do
    @store.find("BClass/b_method").sexp.should be_a_tree_like(s(:defn, :b_method, :*))
  end

  it "should be able to find the duplicately named method in the second class" do
    @store.find("BClass/c_method").sexp.should be_a_tree_like(s(:defn, :c_method, :*))
  end

  it "should not confuse the two duplicately named methods"
  # pending 'cause we don't have a good way to tell which method we've
  # found.
end


describe "Searching for a method buried in conditional logic" do
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
    @store.find("c_method").sexp.should be_a_tree_like(s(:defn, :c_method, :*))
  end

end
