require 'app/rat_catcher_app'

describe "calling the replace_node method" do
  before :each do
    @app= RatCatcherApp.new
    @app.store= RatCatcherStore.parse 'zed'
    @new_text= 'ferd'
    @app.replace_node([], @new_text)
  end

  it "it should change the text of the tree node" do
    @app.store.text.should == @new_text
  end

  it "should change the Sexp of the tree node" do
    @app.store.sexp.should == s(:call, nil, @new_text.to_sym, s(:arglist))
  end

end


describe "calling the rename_method method for a more complex method call" do
  before :each do
    @app= RatCatcherApp.new
    @app.store= RatCatcherStore.parse '1+1'
    @new_text= "-"
    @app.replace_node([], @new_text)
  end
  
  it "should change the Sexp of the tree node" do
    @app.store.sexp.should == s(:call, s(:lit, 1), @new_text.to_sym, s(:arglist, s(:lit, 1)))
  end

end


describe "calling the replace_node method for a non-root method call" do
  before :each do
    @app= RatCatcherApp.new
    @app.store= RatCatcherStore.parse '1+2+3'
    @new_text= "-"
    @app.replace_node([0], @new_text)
  end

  it "should change the Sexp of the tree node" do
    @app.store.sexp.should == s(:call, 
                                s(:call, s(:lit, 1), :-, s(:arglist, s(:lit, 2))),
                                :+,
                                s(:arglist, s(:lit, 3)))
   end
  
end
