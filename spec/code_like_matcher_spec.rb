require_relative 'code_like_matcher'

describe 'code_like_matcher' do
  before :each do
    @code_without_extra_space= 'a=1'
    @code_with_extra_space= 'a = 1'
  end

  it 'should match with the extra_space on the right' do
    pending
    expect(@code_without_extra_space).to be_code_like(@code_with_extra_space)
  end

  it 'should match with the extra_space on the left' do
    pending
    expect(@code_with_extra_space).to be_code_like(@code_without_extra_space)
  end
end

describe 'code_like_matcher' do
  before :each do
    @code_without_extra_space= 'a=2'
    @code_with_extra_space= 'a = 1'
  end

  it 'should not match' do
    expect(@code_without_extra_space).not_to be_code_like(@code_with_extra_space)
  end

end

describe "messages for matcher" do
  before :each do
    @matcher = CodeLikeMatcher.new("a=1")
    @matcher.matches?("a =2")
  end

  it "has appropriate failure message" do
    expect(@matcher.failure_message).to eq("expected \"a =2\" to be code like \"a=1\"")
  end

  it "has appropriate negative failure message" do
    expect(@matcher.failure_message_when_negated).to eq("expected \"a =2\" not to be code like \"a=1\"")
  end
end

