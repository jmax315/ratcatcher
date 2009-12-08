cur_dir= File.expand_path(File.dirname(__FILE__))
require cur_dir + '/variable_rename_processor'
require 'ruby2ruby'


describe 'variable assignment' do
  before :each do
    @source= %q{
      class Foo
        def my_method
	  current_name = 2
	  baz = 8
	end
        def not_my_method
	  current_name = 5
	end
      end
    }
    @tree= RubyParser.new.process(@source)
  end

  it 'should rename a_variable' do
    processor = VariableRenameProcessor.new('current_name', 'new_name')
    new_tree= processor.process(@tree)
    p new_tree
    new= Ruby2Ruby.new.process(new_tree)
    new= strip_ws(new)
    new.should == strip_ws(%q{
      class Foo
        def my_method
	  new_name = 2
	  baz = 8
	end
        def not_my_method
	  new_name = 5
	end
      end
    })
  end

  def strip_ws(input_string)
    output = input_string.gsub(/\s+/, ' ').strip
  end

#   it 'should not rename the_wrong_variable' do
#     @tree.apply(:rename_variable, 'the_wrong_variable', 'new_name')
#     variable_should_be('a_variable')
#   end
end
# vim:sw=2:ai
