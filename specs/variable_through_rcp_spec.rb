cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/../app/rat_catcher_store'
require cur_dir + '/../app/tree_like_matcher'


describe 'variable assignment' do
  def variable_should_be(name)
    @tree.sexp.should be_a_tree_like(s(:lasgn, name.to_sym, :_))
    @tree.source.should == "#{name} = 5"
  end

  before :each do
    # @input= StringIO.new("1\n[\"create_project_item\", \"a_variable = 5\"]\n" +
    #                      "1\n[\"code_from_cookie\", \"#{@magic_cookie}\"]\n")
    # @output= StringIO.new
    # @the_app= RatCatcherApp.new(@input, @output)
    # @the_app.command_loop
    # @magic_cookie= @output.to_s

    # @the_app.command_loop

    # @refactored_code= 
  end

  it 'should rename a_variable' do
    pending
    @tree.apply(:rename_variable, 'a_variable', 'new_name')
    variable_should_be('new_name')
  end

  it 'should not rename the_wrong_variable' do
    pending
    @tree.apply(:rename_variable, 'the_wrong_variable', 'new_name')
    variable_should_be('a_variable')
  end
end

