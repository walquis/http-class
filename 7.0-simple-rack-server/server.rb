require 'rack'
require 'pry'

class HelloWorld
  def response env
    binding.pry
    [ 200, { }, [ 'Hello World' ] ]
  end
end

class HelloWorldApp
  def self.call(env)
    HelloWorld.new.response(env)
  end
end

Rack::Server.start :app => HelloWorldApp
