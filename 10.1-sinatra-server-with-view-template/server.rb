# Run with 'bundle exec ruby server.rb'
require 'sinatra'
require 'pry'
#set :bind, '0.0.0.0' # Listen on any interface

get "/" do
  @valueFromDb = "Deshawn"
  #puts "PARAMS: " + params.inspect
  #puts "HEADERS: " + headers.inspect
  #puts "request method: " + request.request_method
  #puts "request env: " + request.env.inspect
  #binding.pry
  erb :index
end

post "/" do
  'You Did it!'
end
