require 'json'

class RatCatcherApp
  def invoke(wrapped_call)
    unwrapped_call= JSON.parse wrapped_call
    send(*unwrapped_call).to_json
  end
end
