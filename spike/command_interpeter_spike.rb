require 'app/rat_catcher_app'

@output_stream_sink, @output_stream = IO.pipe
@input_stream, @input_stream_source = IO.pipe

if !fork
  @input_stream_source.close
  @output_stream_sink.close

  @rat_catcher= RatCatcherApp.new(@input_stream, @output_stream)
  def @rat_catcher.an_arbitrary_method
    "[\"the results\"]\n"
  end

  @rat_catcher.interpret_commands
  @rat_catcher.interpret_commands
  Kernel.exit!
else
  @input_stream.close
  @output_stream.close

  puts "Got here 1"

  @input_stream_source.write("1\n[\"an_arbitrary_method\"]\n")

  puts "Got here 2"

  first_return_stream= @output_stream_sink.readline
  first_return_stream= @output_stream_sink.readline

  puts "Got here 3"

  if first_return_stream != "1\n[\"the results\"]\n"
    puts "Failed here(1): #{first_return_stream.inspect}"
  end

  puts "Got here 4"

  @input_stream_source.write("1\n[\"an_arbitrary_method\"]\n")

  puts "Got here 5"

  second_return_stream= @output_stream_sink.readline
  second_return_stream= @output_stream_sink.readline

  puts "Got here 6"

  if second_return_stream != "1\n[\"the results\"]\n"
    puts "Failed here(2): #{second_return_stream.inspect}"
  end

  puts "Got here 7"

end
