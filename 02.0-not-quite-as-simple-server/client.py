import socket # A library built into Ruby - provides the TCPSocket class 
import time
 
socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
socket.connect(('localhost', 8080))
# What if we connect but don't send anything just yet?
# How would the server behave if the server is set to non-blocking recv()?
# time.sleep(10)
socket.send("Hi there, server!".encode('utf8'))
print("CLIENT: Sent 'Hi there, server!' to server")
response_from_server = socket.recv(1024)
socket.close()
print("FROM SERVER: {0}".format(response_from_server))
print("CLIENT: Now I'm exiting")
