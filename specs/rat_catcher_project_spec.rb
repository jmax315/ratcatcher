cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_project'


describe 'not loading any code chunks' do
  it 'should have zero code chunks' do
    project= RatCatcherProject.new
    project.size.should == 0
  end
end

describe 'loading one code chunk' do
  before :each do
    @project= RatCatcherProject.new
    @project['first chunk']= 'contents'
  end

  it 'should have one code chunk' do
    @project.size.should == 1
  end

  it 'should reproduce the chunk contents' do
    @project['first chunk'].should == 'contents'
  end

end


describe 'applying a rename-variable refactoring to a single-item project' do
  it "should rename the variable" do
    project= RatCatcherProject.new
    project["first chunk"]= "old_name = 5"
    project.apply(:rename_variable, "old_name", "new_name")

    project["first chunk"].should == "new_name = 5"
  end
end

describe 'applying a rename-variable refactoring to a two-item project' do
  before :each do
    @project= RatCatcherProject.new
    @project["first chunk"]= "old_name = 7"
    @project["second chunk"]= "old_name = 5"
    @project.apply(:rename_variable, "old_name", "new_name")
  end

  it "should rename the variable in the first item" do
    @project["first chunk"].should == "new_name = 7"
  end

  it "should rename the variable in the second item" do
    @project["second chunk"].should == "new_name = 5"
  end
end
