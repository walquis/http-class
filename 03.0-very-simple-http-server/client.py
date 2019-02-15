import socket # A library built into Ruby - provides the TCPSocket class 
 
socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
socket.connect(('localhost', 8080))
socket.send("Hi there, server!".encode('utf8'))
print("CLIENT: Sent 'Hi there, server!' to server")
response_from_server = socket.recv(1024)
socket.close()
print("FROM SERVER: {0}".format(response_from_server))
print("CLIENT: Now I'm exiting")
