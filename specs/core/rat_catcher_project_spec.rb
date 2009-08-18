cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../../app/rat_catcher_project'

class RecordingOutputVisitor
  attr_reader :count

  def initialize
    @count= 0
  end
end

describe 'not loading any code chunks' do
  it 'should have zero code chunks' do
    output_visitor= RecordingOutputVisitor.new
    project= RatCatcherProject.new
    project.apply(output_visitor)
    output_visitor.count.should == 0
  end
end
