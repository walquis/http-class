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

  if uri == '/caroline'
    socket.print("HTTP/1.1 200 OK\r\n")
    socket.print("\r\n")
    if method == 'POST'
      socket.puts("Saved #{uri} to DB!")
    else
      socket.puts("Hello, #{uri}")
    end
  elsif uri == '/'
    socket.print("HTTP/1.1 200 OK\r\n")
    socket.print("Content-type: text/html\r\n")
    socket.print("\r\n")
    socket.print('<html><body><form method="POST" action="/caroline"><input type="submit"></input><input value="data" name="myinput"></input></form></body></html>')
  else
    socket.print("HTTP/1.1 200 OK\r\n")
    socket.print("Content-type: text/html\r\n")
    socket.print("\r\n")
    socket.print('Got it')
  end
  socket.close
end
puts "SERVER: now I'm exiting"
