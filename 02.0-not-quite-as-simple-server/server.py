import socket
import os
import sys

sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 1)  # Line-buffer output to STDOUT.
listener = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
listener.bind(('0.0.0.0', 8080))
listener.listen(5)
(socket,address) = listener.accept()  # Wait til a client connects, then open a socket.
#socket.setblocking(False)
print("FROM THE CLIENT: " + socket.recv(1024))
socket.send("Hello, world".encode('utf8'))
print("SERVER: Sent 'Hello, world' response to client")
socket.close()
print("SERVER: now I'm exiting")
