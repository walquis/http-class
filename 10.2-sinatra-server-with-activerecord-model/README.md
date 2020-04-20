# Adding an ActiveRecord Model to a Simple Sinatra App

## Overview

In this exercise, we start with a Sinatra app containing a single view.  The user is currently being faked by a hardcoded 'User' class defined in server.rb.  However, user data really belongs in a database, and handled by an Object-Relational Mapping (ORM) tool supporting the 'Model' part of the MVC (Model-View-Controller) pattern that is common to many webapps.

The steps for adding a database-backed user model:
1. Set up a simple database with minimal user data
1. Put the ActiveRecord machinery into place.
1. Install a webapp shell tool ('racksh') to test your model and make sure everything's working.
1. Finally, have your webapp itself query the user data from the DB via the User model, and display it in the view.

## Set up a database with user data
First, let's initialize a database.  We'll use Sqlite3.  (All bash commands assume your current directory is at the workspace root).
```
$ brew install sqlite  #  If on a mac and 'sqlite3' returns 'command not found'.
$ mkdir db
$ sqlite3 db/development.sqlite3

sqlite> create table users ( id integer primary key, firstname string, login string );
```

Now add a record:
```
sqlite> insert into users values (1, 'Bob', 'bloblaw');
```

Check that you can query it back:
```
sqlite> select * from users;
1|Bob|bloblaw
sqlite>
```

Quit sqlite3:
```
sqlite> .q  # or Ctrl-D
```

## Set up ActiveRecord
Create an ActiveRecord model for accessing your data.

### Define the model
```
$ mkdir models
```

Create a models/user.rb file with this content:
```
class User < ActiveRecord::Base
end
```

### Tell your app how to load ActiveRecord and your User model
Add these lines near the top of server.rb...
```
require 'sinatra/activerecord'
require './models/user'
```

### Tell ActiveRecord where the database is: 
```
$ mkdir config   # This is where ActiveRecord expects to find database.yml
```

Create a config/database.yml file with this content (between the lines):
```
development:
  adapter: sqlite3
  database: db/development.sqlite3
```

## Add racksh, to test querying data via the User model
Add the 'racksh' gem to your Gemfile and run 'bundle install'.
```
gem 'racksh'
```
Like Sinatra, racksh sits on the [Rack](https://github.com/rack/rack){:target="_blank"} webserver interface, which expects a 'config.ru' file for instructions on running your app.  Add this content to 'config.ru':
```
require './server'
run Sinatra::Application
```

Now run racksh:
```
$ bundle exec racksh
Rack::Shell v1.0.0 started in development environment.
[1] pry(main)> User.first
D, [2020-04-20T16:24:18.436094 #35928] DEBUG -- :    (1.2ms)  SELECT sqlite_version(*)
D, [2020-04-20T16:24:18.437602 #35928] DEBUG -- :   User Load (0.1ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT ?  [["LIMIT", 1]]
=> #<User:0x00007fe5da5f4d68 id: 1, firstname: "Bob", login: "bloblaw">
[2] pry(main)> quit
$
```

## Query the user data from the DB via the User model and display it in the view.
Change server.rb's '/' route to query via ActiveRecord User model, instead of the hardcoded MyUser object:
```
  # @user = MyUser.new(firstname: 'John')
  login = 'bloblaw'
  @user = User.find_by login: login
```

If it's all working, then you will see the 'Bob' user data displayed in your view, pulled from the Sqlite3 database through the 'sqlite3' adapter for the ActiveRecord ORM!
