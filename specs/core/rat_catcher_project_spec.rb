cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../../app/rat_catcher_project'
require cur_dir + '/../../app/recording_visitor'


describe 'not loading any code chunks' do
  it 'should have zero code chunks' do
    output_visitor= RecordingVisitor.new
    project= RatCatcherProject.new
    project.apply(output_visitor)
    output_visitor.size.should == 0
  end
end

describe 'loading one code chunk' do
  before :each do
    @output_visitor= RecordingVisitor.new
    project= RatCatcherProject.new
    project["first chunk"]= "contents"
    project.apply(@output_visitor)
  end

  it 'should have one code chunk' do
    @output_visitor.size.should == 1
  end

  it 'should reproduce the chunk contents' do
    @output_visitor['first chunk'].should == 'contents'
  end

  it 'should allow application of a refactoring'
end
