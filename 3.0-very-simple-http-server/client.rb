require 'socket' # A library built into Ruby - provides the TCPSocket class

socket = TCPSocket.open('localhost',8080)
socket.sync = 1
socket.print "GET / HTTP/1.1\r\n"
puts "CLIENT: Sent an HTTP request"
socket.print "\r\n"
response_from_server = socket.readline
socket.close
# Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
(ver,stat,reason) = response_from_server.split(' ')
puts "FROM SERVER: " + response_from_server
puts "CLIENT: Now I'm exiting"
