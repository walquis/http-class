import socket # A library built into Ruby - provides the TCPSocket class 
from unbuffered_reading import read_line_unbuffered_from
 
socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
socket.connect(('localhost', 8080))
socket.send("Hi there, server!\r\n\r\n".encode('utf8'))
print("CLIENT: Sent 'Hi there, server!' to server")
response_from_server = read_line_unbuffered_from(socket).decode('utf8')
socket.close()
print("FROM SERVER:\n" + response_from_server)
print("CLIENT: Now I'm exiting")
