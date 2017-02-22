require_relative '../app/rat_catcher_app'

describe "encoding the Rat Catcher Protocol" do
  before :each do
    @output_stream= StringIO.new("", "w")
  end

  it "should include line count followed by JSON encoding" do
    RatCatcherApp.new(nil, @output_stream).rcp_write("a_string\n")
    expect(@output_stream.string).to eq("1\na_string\n")
  end

  it "should encode multi-line strings" do
    RatCatcherApp.new(nil, @output_stream).rcp_write("line 1\nline2\n")
    expect(@output_stream.string).to eq("2\nline 1\nline2\n")
  end

  it "should append a newline if none at end" do
    RatCatcherApp.new(nil, @output_stream).rcp_write("a_string")
    expect(@output_stream.string).to eq("1\na_string\n")
  end

  it "should even append a newline to multi-line strings if needed" do
    RatCatcherApp.new(nil, @output_stream).rcp_write("line 1\nline2")
    expect(@output_stream.string).to eq("2\nline 1\nline2\n")
  end
end

describe "decoding the Rat Catcher Protocol" do
  it "should handle 1 line JSON" do
    expected_string= "[\"do_something_else\",\"an argument\"]\n"
    input_stream= StringIO.new("1\n#{expected_string}")
    expect(RatCatcherApp.new(input_stream, nil).rcp_read).to eq(expected_string)
  end

  it "should handle two-line JSON" do
    expected_string= "[\"do_something_else\",\n\"an argument\"]\n"
    input_stream= StringIO.new("2\n#{expected_string}")
    expect(RatCatcherApp.new(input_stream, nil).rcp_read).to eq(expected_string)
  end

  it "should handle multi-line JSON" do
    expected_string= "[\n\"do_something_else\",\n\"an argument\"\n]\n"
    input_stream= StringIO.new("4\n#{expected_string}")
    expect(RatCatcherApp.new(input_stream, nil).rcp_read).to eq(expected_string)
  end
end

describe "invoking a method" do
  before :each do
    @rat_catcher= RatCatcherApp.new
  end

  it "should call the method specified" do
    expect(@rat_catcher).to receive(:do_something)
    encoded_call= ['do_something'].to_json
    @rat_catcher.invoke(encoded_call)
  end

  it "should call a different method" do
    expect(@rat_catcher).to receive(:do_something_else)
    encoded_call= ['do_something_else'].to_json
    @rat_catcher.invoke(encoded_call)
  end

  it "should pass an argument to the method" do
    expect(@rat_catcher).to receive(:do_something_else).with("an argument")
    encoded_call= ['do_something_else', 'an argument'].to_json
    @rat_catcher.invoke(encoded_call)
  end

  it "should handle multi-line calls" do
    expect(@rat_catcher).to receive(:do_something_else).with("an argument")
    encoded_call= "[\n  \"do_something_else\",\n  \"an argument\"\n]\n"
    @rat_catcher.invoke(encoded_call)
  end

  it "should receive an encoded return value" do
    expect(@rat_catcher).to receive(:do_something_else).and_return("ferd")
    encoded_call= ['do_something_else'].to_json
    expect(@rat_catcher.invoke(encoded_call)).to eq("[\"ferd\",\"\"]")
  end

  it "should receive an encoded return value containing a newline" do
    expect(@rat_catcher).to receive(:the_method).and_return("line 1\nline2\n")
    encoded_call= ['the_method'].to_json
    expect(@rat_catcher.invoke(encoded_call)).to eq("[\"line 1\\nline2\\n\",\"\"]")
  end
end

describe "handling a Ruby error" do
  before :each do
    @rat_catcher= RatCatcherApp.new
  end

  it "should return an error indicator" do
    encoded_call= ['non_function'].to_json
    result= JSON.parse(@rat_catcher.invoke(encoded_call))
    expect(result[0]).to be_nil
    expect(result[1]).to match(/undefined method `non_function' for #<RatCatcherApp:0x[0-9A-Fa-f]+>/)
  end
end

describe "handling an input stream" do
  it "should call a single-line command" do
    encoded_call= "1\n[\"do_something_else\",\"an argument\"]\n"
    input_stream= StringIO.new(encoded_call)
    expect(RatCatcherApp.new(input_stream, nil).rcp_read).to eq("[\"do_something_else\",\"an argument\"]\n")
  end

  it "should call a multi-line command" do
    encoded_call= "4\n[\n  \"do_something_else\",\n  \"an argument\"\n]\n"
    input_stream= StringIO.new(encoded_call)
    expect(RatCatcherApp.new(input_stream, nil).rcp_read).to eq("[\n  \"do_something_else\",\n  \"an argument\"\n]\n")
  end
end

describe "the command interpreter" do
  before :each do
    @output_stream_sink, @output_stream = IO.pipe
    @input_stream, @input_stream_source = IO.pipe
  end

  it "should capture an input command and return the results" do
    if !fork
      @input_stream_source.close
      @output_stream_sink.close

      @rat_catcher= RatCatcherApp.new(@input_stream, @output_stream)
      @rat_catcher.stub!(:an_arbitrary_method).and_return("the results")
      @rat_catcher.command_loop
      Kernel.exit!
    else
       @input_stream.close
      @output_stream.close
      encoded_call= "1\n[\"an_arbitrary_method\"]\n"
      @input_stream_source.write(encoded_call)

      expect(@output_stream_sink.gets).to eq("1\n")
      expect(@output_stream_sink.gets).to eq("[\"the results\",\"\"]\n")
    end
  end

  it "should handle multiple commands (loop)" do
    if !fork
      @input_stream_source.close
      @output_stream_sink.close

      @rat_catcher= RatCatcherApp.new(@input_stream, @output_stream)

      @rat_catcher.stub!(:an_arbitrary_method).and_return("the results")
      @rat_catcher.stub!(:another_method).and_return("the other results")

      @rat_catcher.command_loop

      Kernel.exit!
    else
      @input_stream.close
      @output_stream.close

      encoded_call= "1\n[\"an_arbitrary_method\"]\n"
      @input_stream_source.write(encoded_call)

      expect(@output_stream_sink.gets).to eq("1\n")
      expect(@output_stream_sink.gets).to eq("[\"the results\",\"\"]\n")

      encoded_call= "1\n[\"another_method\"]\n"
      @input_stream_source.write(encoded_call)

      expect(@output_stream_sink.gets).to eq("1\n")
      expect(@output_stream_sink.gets).to eq("[\"the other results\",\"\"]\n")
    end
  end

end
