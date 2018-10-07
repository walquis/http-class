require 'socket' # A library built into Ruby - provides the TCPServer class
require 'pry'
require '../lib/unbuffered'
require 'uri'

listener = TCPServer.open(8080)
$stdout.sync = 1  # Line-buffer output to STDOUT.
loop do
  socket = listener.accept  # Wait til a client connects, then open a socket.
  raw_txt = read_line_unbuffered_from socket # The first line, which is the Request-Line
  puts raw_txt
  (method,uri,version) = raw_txt.strip.split(' ')

  # Now the headers
  while raw_txt = read_line_unbuffered_from(socket) do # The first line, which is the Request-Line
    puts raw_txt
    if raw_txt =~ /Content-Length:/
      (hname,content_length) = raw_txt.split(' ')
    end
    break if raw_txt == "\r\n"  # i.e., CRLF
  end
  if method == "GET" and uri == '/'  # Display the form
    request_body = IO::read './form.html'
    socket.print("HTTP/1.1 200 OK\r\nContent-Length: #{request_body.length}\r\n\r\n#{request_body}")
  elsif method=='POST' and uri=='/'  # Form submitted
    request_body = read_body_from socket, content_length.to_i
    puts "BODY: " + request_body
    
    # Read params from the request body of the POST ...
    phash = Hash[ *URI.decode_www_form(request_body).flatten ]
    response_body = "<p>Hi #{phash['name']},</p><p>Welcome to #{phash['place']}!</p></p><a href=\"/\">Back</a>"
    socket.print("HTTP/1.1 200 OK\r\nContent-Length: #{response_body.length}\r\n\r\n#{response_body}")
  else
    socket.print("HTTP/1.1 400 Bad Request\r\n\r\n")
  end
  socket.close
end
puts "SERVER: now I'm exiting"
