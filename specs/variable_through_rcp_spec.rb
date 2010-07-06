require 'json'
cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'
require cur_dir + '/../app/rat_catcher_app'
require cur_dir + '/../app/tree_like_matcher'


def rcp_decode(s)
  answer_json= s[s.index("\n")..-1]
  @unpacked_answer= JSON.parse(answer_json)
  @unpacked_answer[0]
end


describe 'loading code' do
  before :each do
    @input= StringIO.new
    @output= StringIO.new
    @the_app= RatCatcherApp.new(@input, @output)
    @src= "a_variable = 5"

    @input.string= "1\n[\"create_project_item\", \"#{@src}\"]\n"
    @output.string= ""
    @the_app.command_loop
    @magic_cookie= rcp_decode(@output.string)

    @input.string= "1\n[\"code_from_cookie\", #{@magic_cookie}]\n"
    @output.string= ""
    @the_app.command_loop
    @retrieved_code= rcp_decode(@output.string)
  end

  it 'should get the code back' do
    @retrieved_code.should == @src
  end

  it 'should not rename the_wrong_variable' do
    pending
    @tree.apply(:rename_variable, 'the_wrong_variable', 'new_name')
    variable_should_be('a_variable')
  end
end

