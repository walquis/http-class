require 'socket' # A library built into Ruby - provides the TCPSocket class 
 
socket = TCPSocket.open('localhost',8080)
response_from_server = socket.read
socket.close
puts "FROM SERVER: " + response_from_server
puts "CLIENT: Now I'm exiting"
