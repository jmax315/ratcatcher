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
end

describe 'renaming a variable' do
  before :each do
    @input= StringIO.new
    @output= StringIO.new
    @the_app= RatCatcherApp.new(@input, @output)
    @src= "a_variable = 5"

    @input.string= "1\n[\"create_project_item\", \"#{@src}\"]\n"
    @output.string= ""
    @the_app.command_loop
    @magic_cookie= rcp_decode(@output.string)

    @input.string= "1\n[\"rename_variable\", #{@magic_cookie}, \"a_variable\", \"different_variable\"]\n"
    @output.string= ""
    @the_app.command_loop

    @input.string= "1\n[\"code_from_cookie\", #{@magic_cookie}]\n"
    @output.string= ""
    @the_app.command_loop
    @retrieved_code= rcp_decode(@output.string)
  end

  it 'should work for a simple case' do
    @retrieved_code.should == "different_variable = 5"
  end
end
