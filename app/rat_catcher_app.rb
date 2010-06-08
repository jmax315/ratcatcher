require 'json'
require File.expand_path(File.dirname(__FILE__)) + '/rat_catcher_store'

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

  def invoke(wrapped_call)
    unwrapped_call= from_json(wrapped_call)
    send(*unwrapped_call).to_json
  end

  def from_rcp
    line_count= @input_stream.gets.to_i
    payload= ""
    line_count.times do
      payload += @input_stream.gets
    end
    payload
  end

  def interpret_commands
    while true do
      wrapped_call= from_rcp
      break if wrapped_call == ""
      result= invoke(wrapped_call)
      to_rcp(result)
    end
  end

  def create_project_item(source_code)
    RatCatcherStore.parse(source_code)
  end
end
