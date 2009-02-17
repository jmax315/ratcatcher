require 'app/rat_catcher_store'


describe 'tree for the numeric literal 1' do
  before :each do
    @tree= RatCatcherStore.new '1'
  end

  it 'should have one node containing 1 in the first column' do
    @tree.get_iter('0')[0].should == '1'
  end

  it 'should have one node containing s(:lit, 1) in the second column' do
    @tree.get_iter('0')[1].should == s(:lit, 1)
  end
end


describe 'tree for the string literal "ferd"' do
   before :each do
     @tree= RatCatcherStore.new '"ferd"'
   end

  it "should have one node containing 'ferd' in the first column" do
    @tree.get_iter("0")[0].should == '"ferd"'
  end

  it "should have one node containing s(:str, 'ferd') in the second column" do
    @tree.get_iter("0")[1].should == s(:str, "ferd")
  end
end


describe 'tree for the expression 1+2' do
  before :each do
    @tree= RatCatcherStore.new '1+2'
  end

  it "should have one top-level node containing + in the first column" do
    @tree.get_iter("0")[0].should == '+'
  end

  it "should have one top-level node containing s(:call, s(:lit,1 ), :+, s(:arglist, s(:lit, 2))) in the second column" do
    @tree.get_iter("0")[1].should == s(:call, s(:lit,1 ), :+, s(:arglist, s(:lit, 2)))
  end

  it "should have a node at 0:0 containing '1' in the first column" do
    @tree.get_iter("0:0")[0].should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) in the second column" do
    @tree.get_iter("0:0")[1].should == s(:lit, 1)
  end

  it "should have a node at 0:1 containing '2' in the first column" do
    @tree.get_iter("0:1")[0].should == '2'
  end

  it "should have a node at 0:1 containing s(:lit, 2) in the second column" do
    @tree.get_iter("0:1")[1].should == s(:lit, 2)
  end

end


describe 'tree for the expression 1-2' do
  before :each do
    @tree= RatCatcherStore.new '1-2'
  end

  it "should have one top-level node containing - in the first column" do
    @tree.get_iter("0")[0].should == '-'
  end

  it "should have one top-level node containing s(:call, s(:lit,1 ), :-, s(:arglist, s(:lit, 2))) in the second column" do
    @tree.get_iter("0")[1].should == s(:call, s(:lit,1 ), :-, s(:arglist, s(:lit, 2)))
  end

  it "should have a node at 0:0 containing '1' in the first column" do
    @tree.get_iter("0:0")[0].should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) in the second column" do
    @tree.get_iter("0:0")[1].should == s(:lit, 1)
  end

  it "should have a node at 0:1 containing '2' in the first column" do
    @tree.get_iter("0:1")[0].should == '2'
  end

  it "should have a node at 0:1 containing s(:lit, 2) in the second column" do
    @tree.get_iter("0:1")[1].should == s(:lit, 2)
  end
end


describe 'tree for the expression 1+(2-3)' do
  before :each do
    @tree= RatCatcherStore.new '1+(2-3)'
  end

  it "should have a node at 0 containing '+' in the first column" do
    @tree.get_iter("0")[0].should == '+'
  end

  it "should have a node at 0 containing s(:call, s(:lit, 1), :+, s(:arglist, s(:call, s(:lit, 2), :-, s(:arglist, s(:lit, 3))))) in the second column" do
    @tree.get_iter("0")[1].should == s(:call, s(:lit, 1), :+, s(:arglist, s(:call, s(:lit, 2), :-, s(:arglist, s(:lit, 3)))))
  end

  it "should have a node at 0:0 containing '1' in the first column" do
    @tree.get_iter("0:0")[0].should == '1'
  end

  it "should have a node at 0:0 containing s(:lit, 1) in the second column" do
    @tree.get_iter("0:0")[1].should == s(:lit, 1)
  end

  it "should have a node at 0:1 containing '-' in the first column" do
    @tree.get_iter("0:1")[0].should == '-'
  end

  it "should have a node at 0:1 containing s(:call, s(:lit, 2), :-, s(:arglist, s(:lit, 3))) in the second column" do
    @tree.get_iter("0:1")[1].should == s(:call, s(:lit, 2), :-, s(:arglist, s(:lit, 3)))
  end

  it "should have a node at 0:1:0 containing '2' in the first column" do
    @tree.get_iter("0:1:0")[0].should == '2'
  end

  it "should have a node at 0:1:0 containing s(:lit, 2) in the second column" do
    @tree.get_iter("0:1:0")[1].should == s(:lit, 2)
  end

  it "should have a node at 0:1:1 containing '3' in the first column" do
    @tree.get_iter("0:1:1")[0].should == '3'
  end

  it "should have a node at 0:1:1 containing s(:lit, 3) in the second column" do
    @tree.get_iter("0:1:1")[1].should == s(:lit, 3)
  end

end


describe 'tree for the expression (1+2)*3' do
  before :each do
    @tree= RatCatcherStore.new '(1+2)*3'
  end

  it "should have a node at 0 containing '*' in the first column" do
    @tree.get_iter("0")[0].should == '*'
  end

  it "should have a node at 0 containing
      s(:call, s(:call, s(:lit, 1), :+, s(:arglist, s(:lit, 2))), :*, s(:arglist, s(:lit, 3)))
      in the second column" do
    @tree.get_iter("0")[1].should == s(:call, s(:call, s(:lit, 1), :+, s(:arglist, s(:lit, 2))), :*, s(:arglist, s(:lit, 3)))
  end

  it "should have a node at 0:0 containing '+' in the first column" do
    @tree.get_iter("0:0")[0].should == '+'
  end

  it "should have a node at 0:0 containing
      s(:call, s(:lit, 1), :+, s(:arglist, s(:lit, 2)))
      in the second column" do
    @tree.get_iter("0:0")[1].should == s(:call, s(:lit, 1), :+, s(:arglist, s(:lit, 2)))
  end

  it "should have a node at 0:1 containing '3' in the first column" do
    @tree.get_iter("0:1")[0].should == '3'
  end

  it "should have a node at 0:1 containing s(:lit, 3) in the second column" do
    @tree.get_iter("0:1")[1].should == s(:lit, 3)
  end
  
  it "should have a node at 0:0:0 containing '1' in the first column" do
    @tree.get_iter("0:0:0")[0].should == '1'
  end
  
  it "should have a node at 0:0:0 containing s(:lit, 2) in the second column" do
    @tree.get_iter("0:0:0")[1].should == s(:lit, 1)
  end

  it "should have a node at 0:0:1 containing '2' in the first column" do
    @tree.get_iter("0:0:1")[0].should == '2'
  end

  it "should have a node at 0:1:1 containing s(:lit, 2) in the second column" do
    @tree.get_iter("0:0:1")[1].should == s(:lit, 2)
  end
end


describe 'tree for the expression f' do
  before :each do
    @tree= RatCatcherStore.new 'f'
  end

  it "should have one top-level node containing f in the first column" do
    @tree.get_iter("0")[0].should == 'f'
  end

  it "should have one top-level node containing
      s(:call, nil, :f, s(:arglist))
      in the second column" do
    @tree.get_iter("0")[1].should == s(:call, nil, :f, s(:arglist))
  end
end


describe 'tree for the expression f()' do
  before :each do
    @tree= RatCatcherStore.new 'f()'
  end

  it "should have one top-level node containing f in the first column" do
    @tree.get_iter("0")[0].should == 'f'
  end

  it "should have one top-level node containing
      s(:call, nil, :f, s(:arglist))
      in the second column" do
    @tree.get_iter("0")[1].should == s(:call, nil, :f, s(:arglist))
  end
end


describe 'tree for the expression f(2,3)' do
  before :each do
    @tree= RatCatcherStore.new 'f(2,3)'
  end

  it "should have one top-level node containing f in the first column" do
    @tree.get_iter("0")[0].should == 'f'
  end

  it "should have one top-level node containing
      s(:call, nil, :f, s(:arglist, s(:lit, 2), s(:lit, 3)))
      in the second column" do
     @tree.get_iter("0")[1].should == s(:call, nil, :f, s(:arglist, s(:lit, 2), s(:lit, 3)))
  end

  it "should have a node at 0:0 containing '2' in the first column" do
    @tree.get_iter("0:0")[0].should == '2'
  end

  it "should have a node at 0:0 containing
      s(:lit, 2)
      in the second column" do
    @tree.get_iter("0:0")[1].should == s(:lit, 2)
  end

  it "should have a node at 0:1 containing '3' in the first column" do
    @tree.get_iter("0:1")[0].should == '3'
  end

  it "should have a node at 0:1 containing s(:lit, 3) in the second column" do
    @tree.get_iter("0:1")[1].should == s(:lit, 3)
  end
end


describe 'tree for the expression f(7)' do
  before :each do
    @tree= RatCatcherStore.new 'f(7)'
  end

  it "should have one top-level node containing f in the first column" do
    @tree.get_iter("0")[0].should == 'f'
  end

  it "should have one top-level node containing
      s(:call, nil, :f, s(:arglist, s(:lit, 7)))
      in the second column" do
     @tree.get_iter("0")[1].should == s(:call, nil, :f, s(:arglist, s(:lit, 7)))
  end

  it "should have a node at 0:0 containing '7' in the first column" do
    @tree.get_iter("0:0")[0].should == '7'
  end

  it "should have a node at 0:0 containing
      s(:lit, 7)
      in the second column" do
    @tree.get_iter("0:0")[1].should == s(:lit, 7)
  end
end


describe 'tree for the expression f(3,6,9)' do
  before :each do
    @tree= RatCatcherStore.new 'f(3,6,9)'
  end

  it "should have one top-level node containing f in the first column" do
    @tree.get_iter("0")[0].should == 'f'
  end

  it "should have one top-level node containing
      s(:call, nil, :f, s(:arglist, s(:lit, 3), s(:lit, 6), s(:lit, 9)))
      in the second column" do
     @tree.get_iter("0")[1].should == s(:call, nil, :f, s(:arglist, s(:lit, 3), s(:lit, 6), s(:lit, 9)))
  end

  it "should have a node at 0:0 containing '3' in the first column" do
    @tree.get_iter("0:0")[0].should == '3'
  end

  it "should have a node at 0:0 containing
      s(:lit, 3)
      in the second column" do
    @tree.get_iter("0:0")[1].should == s(:lit, 3)
  end

  it "should have a node at 0:1 containing '6' in the first column" do
    @tree.get_iter("0:1")[0].should == '6'
  end

  it "should have a node at 0:1 containing s(:lit, 6) in the second column" do
    @tree.get_iter("0:1")[1].should == s(:lit, 6)
  end

  it "should have a node at 0:2 containing '9' in the first column" do
    @tree.get_iter("0:2")[0].should == '9'
  end

  it "should have a node at 0:2 containing s(:lit, 9) in the second column" do
    @tree.get_iter("0:2")[1].should == s(:lit, 9)
  end
end

