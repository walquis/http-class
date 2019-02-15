def read_line_unbuffered_from(s):
  line = ''
  byte = s.recv(1)
  while 1:
    line += byte
    if byte == "\n":
      if line[-2]=="\r":  # Make sure it's \r\n ...
        break
    byte = s.recv(1)
  return line

def read_body_from(s, size):
  body = ''
  bytes_read = 0
  byte = s.recv(1)
  while 1:
    body += byte
    bytes_read += 1
    if bytes_read == size:
      break
    byte = s.recv(1)
  return body
