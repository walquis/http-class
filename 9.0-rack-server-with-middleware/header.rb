class Header
  def initialize(app)
    @app = app
  end

 def call(env)
   status, headers, response = @app.call(env)

   my_contribution = [ '<h1> This should go at the top of every page </h1>' ]

   headers["Content-Length"] = (my_contribution+response.body).join('').length.to_s
   puts "Added Header"

   [status, headers, my_contribution+response.body]
 end
end
