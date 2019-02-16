require 'socket' # A library built into Ruby - provides the TCPServer class
require '../lib/unbuffered'

$stdout.sync = 1  # Line-buffer output to STDOUT.
listener = TCPServer.open(8080)
loop do
  socket = listener.accept  # Wait til a client connects, then open a socket.
  puts "FROM THE CLIENT: "
  txt = read_line_unbuffered_from(socket) # The first line, which is the Request-Line
  (method,uri,version) = txt.strip.split(' ')
  puts "METHOD = #{method}, URI = #{uri}, version = #{version}"

  content_length=0
  while txt = read_line_unbuffered_from(socket)
    puts txt
    if txt =~ /Content-Length:/
      (hname,content_length) = txt.split(' ')
    end
    if txt == "\r\n"  # i.e., CRLF
      puts "SERVER: reached end of request headers"
      break
    end
  end

  # Routing Section
  if method=='GET'
    socket.print("HTTP/1.1 200 OK\r\n")
    socket.print("Content-type: text/html\r\n")
    socket.print("\r\n")
    socket.print('<html><body><form method="POST" action="/">
    <input type="submit">
    <input value="data" name="myinput">
    <input name="2ndinput" value="someOtherDataWoohoo">
    </form></body></html>')
  elsif method=='POST'
    if content_length.to_i > 0
      body = read_body_from(socket, content_length.to_i)
      puts "BODY: " + body

      socket.print("HTTP/1.1 200 OK\r\n")
      socket.print("\r\n")
    end
  end

  socket.close
end
puts "SERVER: now I'm exiting"
