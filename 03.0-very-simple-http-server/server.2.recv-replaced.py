import socket
import os
import sys
from unbuffered_reading import read_line_unbuffered_from

sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 1)  # Line-buffer output to STDOUT.
listener = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
listener.bind(('0.0.0.0', 8080))
listener.listen(5)
while 1:
  (socket,address) = listener.accept()
  print("FROM THE CLIENT: ")
  while 1:
    txt = read_line_unbuffered_from(socket)
    if len(txt)==0:
      break
    print(txt)
    if txt == "\r\n":  # i.e., CRLF
      print("SERVER: reached end of request headers")
      socket.send("Hello, world\n".encode('utf8'))
      print("SERVER: Sent 'Hello, world' response to client")
      socket.close()
      break
print("SERVER: now I'm exiting")
