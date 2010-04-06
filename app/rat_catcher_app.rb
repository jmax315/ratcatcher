require 'json'

class Array
  def to_rcp()
    RatCatcherApp.to_rcp(self)
  end
end

class String
  def to_rcp()
    RatCatcherApp.to_rcp(self)
  end
end

class NilClass
  def to_rcp()
    RatCatcherApp.to_rcp(self)
  end
end

class RatCatcherApp
  def self.to_rcp(call)
    encoded_call= call.to_json
    "1\n" + encoded_call
  end

  def self.from_rcp(wrapped_call)
    count,payload = wrapped_call.split("\n", 2)
    unwrapped_call= JSON.parse(payload)
  end

  def invoke(wrapped_call)
    unwrapped_call= RatCatcherApp.from_rcp(wrapped_call)
    send(*unwrapped_call).to_rcp
  end

  def read_next(input_stream)
    line_count= input_stream.readline.to_i
    payload= ""
    line_count.times do
      payload += input_stream.readline
    end
    payload
  end
end
