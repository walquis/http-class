require 'socket' # A library built into Ruby - provides the TCPServer class

$stdout.sync = 1  # Line-buffer output to STDOUT.
listener = TCPServer.open(8080)
socket = listener.accept  # Wait til a client connects, then open a socket.
socket.puts("Hello, world")
puts "SERVER: Sent 'Hello, world' response to client"
socket.close
puts "SERVER: now I'm exiting"
