def should_find_the_right_store(path, expected_name)
  it "searching for '#{path}' should find #{expected_name}" do
    @store.find(path).should respond_to(:name)
    @store.find(path).name.should == expected_name
  end
end
