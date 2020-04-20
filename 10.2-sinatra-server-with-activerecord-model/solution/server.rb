# Run with 'bundle exec ruby server.rb'
require 'sinatra'
require 'pry'
require 'sinatra/activerecord'
require './models/user'

#set :bind, '0.0.0.0' # Listen on any interface

get "/" do
  # @user = MyUser.new(firstname: 'John') 
  # Now, make it work by defining a 'User' data model with 'firstname' and 'login' attributes
  login = 'bloblaw'
  @user = User.find_by login: login
  erb :index
end

post "/" do
  'You Did it!'
end
