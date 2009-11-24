current_dir= File.expand_path(File.dirname(__FILE__))
require current_dir + '/../../app/rat_catcher_store'
require current_dir + '/path_spec_helpers'


describe "A RatCatcherProject" do
  before :each do
    @store= RatCatcherProject.new
    @store['first_chunk.rb']= 'class Zed; end'
  end

  should_find_the_right_store 'first_chunk.rb', 'ProjectItemStore', 'first_chunk.rb'
  should_find_the_right_store 'first_chunk.rb/Zed', 'ClassStore', 'Zed'
end 
