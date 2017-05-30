require 'socket' # A libary built into Ruby - provides the TCPServer class

listener = TCPServer.open('localhost', 8080)
socket = listener.accept  # Wait til a client connects, then open a socket.
socket.puts(Time.now.ctime)
socket.puts "Hi, I'm the server, and I'm closing my connection with you now. Bye!"
puts "SERVER: Sent message to client"
socket.close
puts "SERVER: now I'm exiting"
