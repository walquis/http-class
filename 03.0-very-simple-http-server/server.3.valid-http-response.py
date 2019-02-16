import socket
import os
import sys
from unbuffered_reading import read_line_unbuffered_from

sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 1)  # Line-buffer output to STDOUT.
listener = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
listener.bind(('0.0.0.0', 8080))
listener.listen(5)
while 1:
  try:
    (socket,address) = listener.accept()
    txt = read_line_unbuffered_from(socket).decode('utf8')
    print("FROM THE CLIENT: ")
    while txt != "\r\n":  # i.e., CRLF
      print(txt)
      txt = read_line_unbuffered_from(socket).decode('utf8')
    print("SERVER: reached end of request headers")
    socket.send("HTTP/1.1 200 OK\r\n".encode('utf8'))
    socket.send("\r\n".encode('utf8'))
    socket.send("Hello, world\n".encode('utf8'))
    print("SERVER: Sent 'Hello, world' response to client")
    socket.close()
  except KeyboardInterrupt:
    print("Caught Ctrl-C, exiting...")
    listener.close()
    exit(1)

print("SERVER: now I'm exiting")
