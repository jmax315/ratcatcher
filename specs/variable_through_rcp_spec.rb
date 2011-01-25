require 'json'
cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'
require cur_dir + '/../app/rat_catcher_app'
require cur_dir + '/../app/tree_like_matcher'


def rcp_decode(s)
  answer_json= s[s.index("\n")..-1]
  @unpacked_answer= JSON.parse(answer_json)
end


class RatCatcherApp
  def do_commands(command)
    if @input_stream == $stdin
      @input_stream= StringIO.new
    end

    if @output_stream == $stdout
      @output_stream= StringIO.new
    end

    @input_stream.string= command
    @output_stream.string= ""

    command_loop

    response= rcp_decode(@output_stream.string)
    if response[1] != ""
      raise response[1]
    end
    response[0]
  end
end


describe 'loading code' do
  before :each do
    @the_app= RatCatcherApp.new
    @src= "a_variable = 5"

    @magic_cookie= @the_app.do_commands(%(1\n["create_project_item", "#{@src}"]\n))

    @retrieved_code= @the_app.do_commands(%(1\n["code_from_cookie", "#{@magic_cookie}"]\n))
  end

  it 'should get the code back' do
    @retrieved_code.should == @src
  end
end

describe 'loading and retrieving code' do
  before :each do
    @the_app= RatCatcherApp.new
    @src= "the_answer = 42"

    @magic_cookie= @the_app.do_commands(%(1\n["create_project_item", "#{@src}"]\n))
  end

  it 'should get the stored code from cookie' do
    retrieved_code= @the_app.do_commands(%(1\n["code_from_cookie", "#{@magic_cookie}"]\n))
    retrieved_code.should == @src
  end
end

describe 'renaming a variable' do
  before :each do
    @the_app= RatCatcherApp.new
    @src= "a_variable = 5"

    @magic_cookie= @the_app.do_commands(%(1\n["create_project_item", "#{@src}"]\n))

    @the_app.do_commands(%(1\n["refactor", "rename_variable", "#{@magic_cookie}", "a_variable", "different_variable"]\n))

    @retrieved_code= @the_app.do_commands(%(1\n["code_from_cookie", "#{@magic_cookie}"]\n))
  end

  it 'should work for a simple case' do
    @retrieved_code.should == "different_variable = 5"
  end
end
