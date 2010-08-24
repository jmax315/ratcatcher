require 'ruby_parser'
require File.expand_path(File.dirname(__FILE__)) + '/code_like_matcher'

describe 'code_like_matcher' do
  before :each do
    @code_without_extra_space= 'a=1'
    @code_with_extra_space= 'a = 1'
  end

  it 'should match with the extra_space on the right' do
    @code_without_extra_space.should be_code_like(@code_with_extra_space)
  end

  it 'should match with the extra_space on the left' do
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

