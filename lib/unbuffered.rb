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
