# Run with 'bundle exec ruby server.rb'
require 'sinatra'
require 'pry'
require 'sinatra/activerecord'
require './models/user'

#set :bind, '0.0.0.0' # Listen on any interface

# Stub class to behave like a model from the view's perspective
# (i.e., respond to 'firstname')
class MyUser
  attr :firstname

  def initialize **args
    @firstname = args[:firstname]
  end
end

get "/" do
  @user = MyUser.new(firstname: 'John')
  # Now, make it work by defining a 'User' data model with 'firstname' and 'login' attributes
  # login = 'bloblaw'
  # @user = User.find_by login: login
  erb :index
end

post "/" do
  'You Did it!'
end
