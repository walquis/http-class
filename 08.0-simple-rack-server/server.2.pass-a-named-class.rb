# Rack spec:  http://www.rubydoc.info/github/rack/rack/master/file/SPEC
require 'rack'
require 'pry'

class HelloWorld
  def response env
    [ 200, { }, [ 'Hello World' ] ]
  end
end

class HelloWorldApp
  def self.call(env)  # Rack will call "call" and pass a filled-in env
    HelloWorld.new.response(env)
  end
end

# You have to pass Rack something that ...
# 1) has a "call" method with env params (the request info), and
# 2) returns a "triplet" consisting of status, headers, and body (the response)
Rack::Server.start app: HelloWorldApp
