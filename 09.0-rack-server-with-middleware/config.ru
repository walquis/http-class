require 'rack'
require './footer'
require 'rack/lobster'

use Footer
run Rack::Lobster.new
