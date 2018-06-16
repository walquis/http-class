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
    puts txt
    if txt =~ /Content-Length:/
      (hname,content_length) = txt.split(' ')
    end
    if txt == "\r\n"  # i.e., CRLF
      puts "SERVER: reached end of request headers"
      break
    end
  end
  body = socket.recv(content_length)
  puts "BODY: " + body

  socket.print("HTTP/1.1 200 OK\r\n")
  socket.print("\r\n")
  socket.close
end
puts "SERVER: now I'm exiting"
