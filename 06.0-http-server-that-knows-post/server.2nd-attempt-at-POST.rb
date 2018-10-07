require 'socket' # A library built into Ruby - provides the TCPServer class
require 'pry'
require '../lib/unbuffered'

$stdout.sync = 1  # Line-buffer output to STDOUT.
listener = TCPServer.open(8080)
loop do
  socket = listener.accept  # Wait til a client connects, then open a socket.
  puts "FROM THE CLIENT: "
  txt = read_line_unbuffered_from(socket) # The first line, which is the Request-Line
  (method,uri,version) = txt.strip.split(' ')
  puts "METHOD = #{method}, URI = #{uri}, version = #{version}"

  while txt = read_line_unbuffered_from(socket)
    puts txt  # Not doing anything with headers right now except printing to console
    break if txt == "\r\n"  # i.e., CRLF on a line by itself...end of headers
    if txt =~ /Content-Length:/
      (hname,content_length) = txt.split(' ')
    end
  end

  body = read_body_from socket, content_length.to_i
  puts "BODY: " + body

  params = body.split /&/
  phash = {}
  params.each do |p|
    (k,v) = p.split '='
    phash[k] =v
  end
  response_body = "<p>Hi #{phash['name']},</p><p>Welcome to #{phash['place']}!</p></p><a href=\"/\">Back</a>"
  socket.print("HTTP/1.1 200 OK\r\nContent-Length: #{response_body.length}\r\n\r\n#{response_body}")
  socket.close
end
puts "SERVER: now I'm exiting"
