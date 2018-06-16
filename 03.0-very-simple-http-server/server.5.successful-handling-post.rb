require 'socket' # A library built into Ruby - provides the TCPServer class
require 'pry'

def read_line_unbuffered_from s
  line = ''
  byte = s.getc
  loop do 
    line += byte
    if byte == "\n"
      break if line[-2]=="\r"  # Make sure it's \r\n ...
    end
    byte = s.getc
  end
  line
end

def read_body_from s, size
  body = ''
  bytes_read = 0
  byte = s.getc
  loop do 
    body += byte
    bytes_read += 1
    break if bytes_read == size
    byte = s.getc
  end
  body
end

$stdout.sync = 1  # Line-buffer output to STDOUT.
listener = TCPServer.open(8080)
loop do
  socket = listener.accept  # Wait til a client connects, then open a socket.
  puts "FROM THE CLIENT: "
  txt = read_line_unbuffered_from(socket) # The first line, which is the Request-Line
  (method,uri,version) = txt.strip.split(' ')
  puts "METHOD = #{method}, URI = #{uri}, version = #{version}"

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
  body = read_body_from(socket, content_length.to_i)
  puts "BODY: " + body

  socket.print("HTTP/1.1 200 OK\r\n")
  socket.print("\r\n")
  socket.close
end
puts "SERVER: now I'm exiting"
