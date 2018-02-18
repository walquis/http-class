class Footer
  SHRIMP_STRING = <<BEGIN
|///
 .*----___// <-- it's supposed to be a walking shrimp...
<----/|/|/|
BEGIN

  def initialize(app)
    @app = app
  end

 def call(env)
   status, headers, response = @app.call(env)

   shrimp = ["<pre>#{SHRIMP_STRING}</pre>"]

   headers["Content-Length"] = (response.body+shrimp).join('').length.to_s

   puts "Added footer"

   [status, headers, response.body+shrimp ]
 end
end
