require 'socket' # A library built into Ruby - provides the TCPSocket class 
 
host = 'localhost'
port = 8080 

socket = TCPSocket.open(host,port)
response = socket.read
puts response
puts "CLIENT: read message from the server, now I'm exiting"
