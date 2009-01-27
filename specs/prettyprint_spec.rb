require 'ruby_parser'
require 'app/pretty_printer'

describe "pretty printing" do
  before :each do
    @parser= RubyParser.new
    @prettyprinter= PrettyPrinter.new
  end

  it "should print a literal node for 1 properly" do
    one_tree= @parser.s(:lit, 1)
    @prettyprinter.print(one_tree).should == 's(:lit, 1)'
  end

  it "should print a literal node for 2 properly" do
    two_tree= @parser.s(:lit, 2)
    @prettyprinter.print(two_tree).should == 's(:lit, 2)'
  end

  it "should print a variable reference for a properly" do
    a_tree= @parser.s(:call, nil, :a, @parser.s(:arglist))
    @prettyprinter.print(a_tree).should == 's(:call, nil, :a, s(:arglist))'
  end

end
