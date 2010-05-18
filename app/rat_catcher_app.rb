require 'json'

class RatCatcherApp
  def initialize(input_stream, output_stream)
    @input_stream = input_stream
    @output_stream = output_stream
  end

  def to_rcp(json_string)
    if (json_string[-1..-1] != "\n")
      json_string += "\n"
    end
    @output_stream.write("#{json_string.count("\n")}\n")
    @output_stream.write(json_string)
  end

  def from_json(payload)
    JSON.parse(payload)
  end

  #TODO change invoke() to return json instead of rcp
  def invoke(wrapped_call)
    unwrapped_call= from_json(wrapped_call)
    send(*unwrapped_call)
  end

  def from_rcp
    line_count= @input_stream.readline.to_i
    payload= ""
    line_count.times do
      payload += @input_stream.readline
    end
    payload
  end

  def interpret_commands
    wrapped_call= from_rcp
    result= invoke(wrapped_call)
    to_rcp(result)
  end
end
