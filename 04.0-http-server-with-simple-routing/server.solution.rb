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

  if method=='GET'
    if uri == '/hi'
      socket.print("HTTP/1.1 200 OK\r\n\r\nHello, World\n")
    elsif uri == '/bye'
      socket.print("HTTP/1.1 200 OK\r\n\r\nGoodbye, World\n")
    else
      socket.print("HTTP/1.1 404 Not Found\r\n")
    end
  else
    socket.print("HTTP/1.1 404 Not Found\r\n")
  end
  socket.close
end
puts "SERVER: now I'm exiting"
