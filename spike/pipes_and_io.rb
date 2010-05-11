rd, wr = IO.pipe
krd, kwr = IO.pipe

if !fork
  rd.close
  kwr.close

  puts "Kid(1) got #{krd.readline}"
  puts "Kid(1) got #{krd.readline}"

  puts "Sending message to parent"
  wr.puts "1"
  wr.puts "Hi Mom"

  puts "Kid(2) got #{krd.readline}"
  puts "Kid(2) got #{krd.readline}"

  wr.puts "1"
  wr.puts "Hi Dad"
  wr.close
  krd.close
else
  wr.close
  krd.close

  kwr.puts "1"
  kwr.puts "Hi Buffy"
  puts "Parent(1) got: <#{rd.readline}>"
  puts "Parent(1) got: <#{rd.readline}>"

  kwr.puts "1"
  kwr.puts "Hi Brad"
  puts "Parent(2) got: <#{rd.readline}>"
  puts "Parent(2) got: <#{rd.readline}>"

  rd.close
  kwr.close
  Process.wait
end
