require 'json'

class Array
 def to_rcp()
 end
end

class String
 def to_rcp()
 end
end

class NilClass
 def to_rcp()
 end
end

class RatCatcherApp
  def self.to_rcp(output_stream, json_string)
    output_stream.write("#{json_string.count('\n')}\n")
    output_stream.write(json_string)
  end

  def self.from_json(payload)
    unwrapped_call= JSON.parse(payload)
  end

  #TODO change invoke() to return json instead of rcp
  def invoke(wrapped_call)
    unwrapped_call= RatCatcherApp.from_json(wrapped_call)
    send(*unwrapped_call).to_rcp
  end

  def self.from_rcp(input_stream)
    line_count= input_stream.readline.to_i
    payload= ""
    line_count.times do
      payload += input_stream.readline
    end
    payload
  end

  def interpret_commands(input_stream, output_stream)
    wrapped_call= RatCatcherApp.read_next(input_stream)
    puts wrapped_call
    result= invoke(wrapped_call)
    output_stream.write(result)
  end
end
