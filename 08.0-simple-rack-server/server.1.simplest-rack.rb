# Rack spec:  http://www.rubydoc.info/github/rack/rack/master/file/SPEC
require 'rack'

# You have to pass Rack something that ...
# 1) responds to a "call" method with env param (the request info), and
# 2) returns a "triplet" consisting of status, headers, and body (the response)
Rack::Server.start app: Class.new do
  def self.call(e)
    [ 200, { }, [ "Hello World\n" ] ]
  end
end
