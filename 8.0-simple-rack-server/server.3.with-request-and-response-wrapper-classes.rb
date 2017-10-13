# Rack spec:  http://www.rubydoc.info/github/rack/rack/master/file/SPEC
require 'rack'
require 'pry'

class HelloWorld
  def response request
    # Instead of  [ 200, { }, [ 'Hello World' ] ]  ...
    my_response = Rack::Response.new
    if request.params['direction'] == 'coming'
      my_response.body = [ 'Hello world' ]
    elsif request.params['direction'] == 'going'
      my_response.body = [ 'Goodbye world' ]
    else
      my_response.body = [ 'Are you going or coming?' ]
    end

    my_response.finish  # Send the response - A Rack triplet
  end
end

class HelloWorldApp
  def self.call(env)  # Rack will call "call" and pass a filled-in env
    request = Rack::Request.new env  # Wrap env in the request class
    # Now you can say things like...
    request.params  # The union of GET and POST params
    request.xhr?  # Was it an AJAX request?
    request.body  # The incoming request stream
    HelloWorld.new.response(request)
  end
end

# Give Rack something that responds to "call(env)" and
# returns a Rack triplet: [ http_status_code, header-hash, body-array ]
Rack::Server.start :app => HelloWorldApp
