require 'rack'
require './footer'
require './header'
require 'rack/lobster'

use Header
use Footer
run Rack::Lobster.new
