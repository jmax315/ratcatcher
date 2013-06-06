require_relative 'code_like_matcher'

describe 'code_like_matcher' do
  before :each do
    @code_without_extra_space= 'a=1'
    @code_with_extra_space= 'a = 1'
  end

  it 'should match with the extra_space on the right' do
    pending
    @code_without_extra_space.should be_code_like(@code_with_extra_space)
  end

  it 'should match with the extra_space on the left' do
    pending
    @code_with_extra_space.should be_code_like(@code_without_extra_space)
  end
end

describe 'code_like_matcher' do
  before :each do
    @code_without_extra_space= 'a=2'
    @code_with_extra_space= 'a = 1'
  end

  it 'should not match' do
    @code_without_extra_space.should_not be_code_like(@code_with_extra_space)
  end

end

describe "messages for matcher" do
  before :each do
    @matcher = CodeLikeMatcher.new("a=1")
    @matcher.matches?("a =2")
  end

  it "has appropriate failure message" do
    @matcher.failure_message.should == "expected \"a =2\" to be code like \"a=1\""
  end

  it "has appropriate negative failure message" do
    @matcher.negative_failure_message.should == "expected \"a =2\" not to be code like \"a=1\""
  end
end

