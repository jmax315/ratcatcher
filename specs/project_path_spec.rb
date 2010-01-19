current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/rat_catcher_store'
require current_dir + '/../app/store_nodes/project_item_store'
require current_dir + '/../app/rat_catcher_project'
require current_dir + '/path_spec_helpers'


describe "A RatCatcherProject" do
  before :each do
    @store= RatCatcherProject.new
    @store['initial_chunk.rb']= 'class Waco; end'
  end

  it "searching for 'initial_chunk.rb' should find initial_chunk.rb" do
    @store.find('initial_chunk.rb').should respond_to(:name)
    @store.find('initial_chunk.rb').name.should == 'initial_chunk.rb'
  end
end 


describe "A RatCatcherProject" do
  before :each do
    @store= RatCatcherProject.new
    @store['first_chunk.rb']= 'class Zed; end'
  end

  it "searching for 'first_chunk.rb/Zed' should find Zed" do
    @store.find('first_chunk.rb/Zed').should respond_to(:name)
    @store.find('first_chunk.rb/Zed').name.should == 'Zed'
  end
end 


describe "A RatCatcherProject" do
  before :each do
    @store= RatCatcherProject.new
    @store['a_chunk.rb']= 'class Rocky; end; class Bullwinkle; end'
  end

  it "searching for 'a_chunk.rb/Bullwinkle' should find Bullwinkle" do
    @store.find('a_chunk.rb/Bullwinkle').should respond_to(:name)
    @store.find('a_chunk.rb/Bullwinkle').name.should == 'Bullwinkle'
  end
end 


describe "A RatCatcherProject" do
  before :each do
    @store= RatCatcherProject.new
    @store['bee_chunk.rb']= 'class Rocky; def fly; end; end'
  end

  it "searching for 'bee_chunk.rb/Rocky/fly' should find fly" do
    @store.find('bee_chunk.rb/Rocky/fly').should respond_to(:name)
    @store.find('bee_chunk.rb/Rocky/fly').name.should == 'fly'
  end
end 
