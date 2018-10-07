require 'socket' # A library built into Ruby - provides the TCPServer class

$stdout.sync = 1  # Line-buffer output to STDOUT.
listener = TCPServer.open(8080)
loop do
  socket = listener.accept  # Wait til a client connects, then open a socket.
  puts "FROM THE CLIENT: "
  txt = socket.readline  # The first line, which is the Request-Line
  (method,uri,version) = txt.strip.split(' ')
  puts "METHOD = #{method}, URI = #{uri}, version = #{version}"

  while txt = socket.readline
    puts txt  # Not doing anything with headers right now except printing to console
    break if txt == "\r\n"  # i.e., CRLF on a line by itself...end of headers
  end

  socket.print("HTTP/1.1 200 OK\r\n")
  socket.print("\r\n")
  socket.puts("Hello, world")
  puts "SERVER: Sent 'Hello, world' response to client"
  socket.close
end
puts "SERVER: now I'm exiting"
