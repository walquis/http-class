require 'socket' # A library built into Ruby - provides the TCPSocket class 
 
host = 'localhost'
port = 8080

socket = TCPSocket.open(host,port)
response_from_server = socket.read
socket.close
puts "FROM THE SERVER: " + response_from_server
puts "CLIENT: Now I'm exiting"
