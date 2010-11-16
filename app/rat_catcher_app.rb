require 'json'
require File.expand_path(File.dirname(__FILE__)) + '/rat_catcher_store'

class RatCatcherApp
  def initialize(input_stream= $stdin, output_stream= $stdout)
    @input_stream = input_stream
    @output_stream = output_stream
    @project_items= {}
  end

  def rcp_write(json_string)
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
    return_value= send(*unwrapped_call)
    [return_value, ""].to_json
  end

  def rcp_read
    payload= ""
    @input_stream.gets.to_i.times do
      payload += @input_stream.gets
    end
    payload
  end

  def command_loop
    until (wrapped_call= rcp_read).length == 0
      result= invoke(wrapped_call)
      rcp_write(result)
    end
  end

  def create_project_item(source_code)
    store= RatCatcherStore.parse(source_code)
    cookie= store.hash.to_s
    @project_items[cookie]= store
    cookie
  end

  def code_from_cookie(cookie)
    File.open("ferd", "a") do |f|
      f.puts "code_from_cookie: cookie: #{cookie.inspect}\n"
    end
    item= @project_items[cookie]
    item && item.source
  end

  def rename_variable(cookie, from, to)
    item= @project_items[cookie]
    if item
      item.apply(:rename_variable, from, to)
    end
  end

  def echo(arg)
    arg
  end
end
