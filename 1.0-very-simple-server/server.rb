require 'socket' # A libary built into Ruby - provides the TCPServer class

host = 'localhost'
port = 8080

listener = TCPServer.open(host, port)
socket = listener.accept  # Wait til a client connects, then open a socket.
socket.puts("Hello, world")
puts "SERVER: Sent message to client"
socket.close
puts "SERVER: now I'm exiting"
