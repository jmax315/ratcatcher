current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../app/rat_catcher_store'
require current_dir + '/../app/store_nodes/project_item_store'
require current_dir + '/../app/rat_catcher_project'
require current_dir + '/path_spec_helpers'


describe "A RatCatcherProject" do
  it "should be fixed"
#   before :each do
#     @store= RatCatcherProject.new
#     @store['initial_chunk.rb']= 'class Waco; end'
#   end

#   should_find_the_right_store 'initial_chunk.rb', 'ProjectItemStore', 'initial_chunk.rb'
end 


describe "A RatCatcherProject" do
  before :each do
    @store= RatCatcherProject.new
    @store['first_chunk.rb']= 'class Zed; end'
  end

  should_find_the_right_store 'first_chunk.rb/Zed', :class, 'Zed'
end 


describe "A RatCatcherProject" do
  before :each do
    @store= RatCatcherProject.new
    @store['a_chunk.rb']= 'class Rocky; end; class Bullwinkle; end'
  end

  should_find_the_right_store 'a_chunk.rb/Bullwinkle', :class, 'Bullwinkle'
end 


describe "A RatCatcherProject" do
  before :each do
    @store= RatCatcherProject.new
    @store['bee_chunk.rb']= 'class Rocky; def fly; end; end'
  end

  should_find_the_right_store 'bee_chunk.rb/Rocky/fly', :defn, 'fly'
end 
