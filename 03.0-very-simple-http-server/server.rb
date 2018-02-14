require 'socket' # A library built into Ruby - provides the TCPServer class

$stdout.sync = 1  # Line-buffer output to STDOUT.
listener = TCPServer.open(8080)
loop do
  socket = listener.accept  # Wait til a client connects, then open a socket.
  puts "FROM THE CLIENT: "
  txt = socket.recv(10000)
  puts txt
  socket.puts("Hello, world")
  socket.close
  puts "SERVER: Sent 'Hello, world' response to client"
end
puts "SERVER: now I'm exiting"
