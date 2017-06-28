require 'rack'
run ->(env) { [200, {"Content-Type" => "text/html"}, ["Hello World!"]] }
