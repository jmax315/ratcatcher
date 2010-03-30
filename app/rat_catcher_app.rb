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
    count,payload = wrapped_call.split("\n")
    unwrapped_call= JSON.parse(payload)
  end

  def invoke(wrapped_call)
    unwrapped_call= RatCatcherApp.from_rcp(wrapped_call)
    send(*unwrapped_call).to_rcp
  end
end
