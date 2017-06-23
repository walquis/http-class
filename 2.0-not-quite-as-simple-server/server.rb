require 'socket' # A library built into Ruby - provides the TCPServer class

host = 'localhost'
port = 8080

listener = TCPServer.open(host, port)
socket = listener.accept  # Wait til a client connects, then open a socket.
puts "FROM THE CLIENT: " + socket.read
socket.puts("Hello, world")
puts "SERVER: Sent message to client"
socket.close
puts "SERVER: now I'm exiting"
