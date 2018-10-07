# HTTP Class
**Goal** - Appreciate the value of HTTP as foundational knowledge for web development

**Objective** - Progress from a very basic client/server app, to an app server built on a web framework.

### Agenda:
* Version 1 - Very Simple Server and Client  - 35-45 minutes
* Version 2 - Not-Quite-As-Simple-Server-and-client - bidirectional communication
* Version 3 - Very Simple HTTP Server (use an existing HTTP client)
* Version 4 [TODO] - Server with simple HTTP routing
* Version 5 - Server with Parameter handling
* Version 6 - Server that handles a POST method
* Version 8 - Simple Rack server
* Version 9 - Rack with middleware
* Version 10 - Very simple Sinatra server - a micro-framework


### Goals
* Get introduced to reading specification documents--in this case, RFC2616, the HTTP 1.1 spec.
* Understand the basic relationship between TCP/IP, HTTP, and HTML.
* Begin to differentiate between message protocols and layers.
* Begin to appreciate what web frameworks do for you behind the scenes.

## Version 1 - Very Simple Server and Client  - 35-45 minutes
**Goal** - Identify some basic networking components on which a server is built.

**Objective** - Establish a "reliable" network connection and transmit data one way.

Setup:
    $ git clone https://github.com/walquis/http-class.

* Receive a request from a client (e.g., client.rb, cURL, and/or telnet), and return "Hello, world".
[Describe server.rb and client.rb and run them side-by-side.  Have the students do it too].

    $ cd 01.0-very-simple-server
    $ ruby server.rb
[ Open another terminal window ]
    $ cd 01.0-very-simple-server
    $ ruby client.rb  # In another window.

Doesn't seem like much, does it?
What happens if you run client.rb first?
What is being done for us here?  What kind of technologies does this server rely on?
* Uses TCP/IP - "Transport Layer" - to establish a persistent connection to an address.
* Notice we said "localhost"--the socket library knows how to map that to an "IP address".
   [What is "IP"?  https://tools.ietf.org/html/rfc791]
* Knows how to listen and wait to establish a connection.
* Socket - "Session Layer" - bi-directional communication.
* Reliable delivery of (all the packets of) the entire (variable-length) message.
* [Briefly discuss "unreliable delivery" - UDP - and packets].
* [Briefly discuss output buffering.  See extra/output-buffering-test.rb]

[Don't dwell on the OSI model, but make point that each layer has defined responsibilities, upon which more functionality can be built].

[Add a loop to the server around the socket-handler:  "loop do ... end"].  Cool!

> Is the client using the same connection every time it talks to the server?

So, this app is a basic example of a TCP/IP client/server architecture.

TAKEAWAY:  This is about the simplest client and server we can imagine, but a LOT is going on under the hood!


What is missing from our client/server architecture?
* useful functionality!  "Hello, world" is not much value-add.
* fault tolerance.  Doesn't try to catch or recover from errors.
* authentication.  No notion of who's connecting.
* scalability.  What happens if thousands of clients try to connect at once?
* multi-user capability.
* (And, we're not relying on domain name resolution).
* Also...BI-DIRECTIONAL DATA TRANSFER--which is critical for webapps.

**Exercise**
Have students try hitting each others' servers from clients on different machines.
Hint: How does the client find the server?  On your Mac, "ifconfig en0 inet" may help.

[Ten-Minute BREAK]


## Version 2 - Not-Quite-As-Simple-Server-and-client - bidirectional communication
**Goal** - Begin to understand how quickly communication gets complicated

**Objective** - Two-way data transfer on the same connection

Notice that in our first client/server app, data only went one way [which way?]...
* Client connects to the server and reads from it, but does not try to write.
* Server accepts the requested connection, and writes "Hello World" back to the client, but does not try to read.

Let's try to make our client and server a little fancier: Have the client write and the server read ON THE SAME CONNECTION.

cd into 02.0-not-quite-as-simple-server, where we've added a client write() and a corresponding server read().

    $ diff ../01.0-very-simple-server/client.rb .
    6a7,8
    > socket.puts "Hi there, server!"
    > puts "CLIENT: Sent message to server"
    $

Client has just two lines added.  How about the server?

    $ cd ../02.0-not-quite-as-simple-server
    diff ../01.0-very-simple-server/server.rb .
    7a8
    > puts "FROM THE CLIENT: " + socket.read
    $

Let's try it!  [Run server.rb, then client.rb]

Why does it hang?  Because by default, socket I/O is "blocking"...the read() waits until the socket is closed before moving on.
The sequence of events:
1. Connection established by opening the socket.
1. Server listens on the socket, waiting to hear what the client has to say. In other words, it "blocks".
1. Client sends its message.
1. Client then also listens on the socket, waiting to hear the server's response.

[Any volunteers to describe the issue?]  Client is waiting on the server, but it will never hear from the server, because the server is waiting on the client.  Because TCP supports variable-length messages, there might be more data coming.  How does the read() know the message is complete?  For blocking reads, it doesn't know until the other end closes the socket.]
5. So, both ends are waiting for the other to terminate the connection.

How might we get around this issue?
[Hint: I said the *default* is to block...what if we could change the default?]

You can see that it's starting to get messy...!

One way to describe this problem is the "Over" problem (from radio communications).

What do we need?  Some agreed-upon signal when to stop reading.  Several options...
* Agree how long the message will be, and read only that much, or...
* Read until you see a special character (which one??), or...
* Read non-blocking.

For now, let's just go with non-blocking.


**Exercise**

See if you can get this example to work by replacing read() with recv(some-static-number-of-bytes).

**Solution**

server.rb:

    puts "FROM THE CLIENT: " + socket.recv(10000)

* To make this example work, we only have to do it on one side. [Why?]
* What's wrong with this implementation?
ANSWER: We're assuming a maximum length.  What kind of message could be longer than 10,000 bytes...?
* What would happen if we only read 10 bytes?  socket.recv(10)
* What would we get if we added another socket.recv(10)  ?  [Talk about buffering]


## Version 3 - Very Simple HTTP Server (use an existing HTTP client)
**Goals**
* Understand what makes a server specifically an "HTTP" server.
* Deepen appreciation of why HTTP is necessary.

**Objective** - Send valid HTTP request, and return valid HTTP response.

* "What makes a server an "HTTP" server?"  It sends HTML?  (Not exactly; it could send JSON, or CSV, or a file attachment, and still be an "HTTP" server).
ANSWER: It communicates by implementing the HTTP protocol specification.
* [What is HTTP an acronym for?  What is "Hypertext"?]
* "What is a protocol?"  [A basis for communication; a code of correct conduct; a set of common, identifiable, and perhaps negotiable assumptions]
* [What is the difference between TCP/IP and HTTP?]

BTW...Earlier, I mentioned that bi-directional data transfer is needed for webapps.

How do we know this?  *By looking at the spec*. Let's take a look at the HTTP 1.1 spec and see how HTTP clients and servers are supposed to communicate.

https://tools.ietf.org/html/rfc2616 - The answer to "Where do they come up with this stuff?"

    Section 1.4 - "In the simplest case, this may be accomplished VIA A SINGLE CONNECTION."

There it is!

How close to HTTP is what we have already?
* Can our server communicate with an HTTP client? [Let's try it]
* Can our client communicate with an HTTP server? [Let's try it]

FIRST - How could we try hitting our server.rb with an HTTP client?

    $ cd ../03.0-very-simple-http-server
    $ ruby server.rb

What is an HTTP client we could use?  [curl, Chrome, ...]

[Hit http://localhost:8080 with Chrome.  Look at the output.  Look at the response headers in Chrome.]

[Examine the server output, talk about what we see.  For instance: Is our server sending valid HTTP?  Why isn't Chrome complaining? ]
[Look at the response headers in Chrome.]


How about curl (as a client)?   '-i' in curl shows response headers, if there are any.
```bash
    $ curl -i http://localhost:8080
```
Let's look at the HTTP 1.1 spec in some more detail: https://tools.ietf.org/html/rfc2616
```
    1.1 Purpose
```
* "request/response"
* "open-ended set of methods and headers that indicate the purpose of a request"
* URL as "the resource to which the method is to be applied"
* "Messages are passed in a format similar to that used by Internet mail as defined by the Multipurpose Internet Mail Extensions (aka MIME)."

```
    1.4 Overall Operations
```

* "request/response protocol"
* Client sends Request: Method, URI, protocol version, followed by MIME-like message.
* Server responds with status line including msg protocol version and success-or-error-code, followed by MIME-like message.

```
    5 Request

    Request = Request-Line;
       *(( general-header
       | request-header
       | entity-header ) CRLF)
      CRLF
      [ message-body ]

    5.1 - Request-Line
    Request-Line = Method SP Request-URI SP HTTP-Version CRLF
```

What does all this mean?  [Skim over BNF notation, cut to the chase: "A line with an HTTP method, space, URL, space, HTTP/1.1"
* HTTP is a request/response protocol.
* What does a valid HTTP request look like?  [ Examine server.rb's console output--compare with spec. ]
Have any of you seen this before?  [They may have, from material earlier in the week]

How about the response...
* Is the server giving the client a response?
* What kind of response is the server giving it?  Not a very good one...
* What is wrong with the response?  (no request-line headers at all!)


What should a valid HTTP response look like?  Where should we look?  The spec of course...
```
    6 Response
    Response = Status-Line
         *(( general-header
          | response-header
          | entity-header ) CRLF)
         CRLF
         [ message-body ]
    6.1 Status-Line
    Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```
Notice that the HTTP response format looks a lot like the HTTP request format!

What's different?  The first line...
```
    Request:    Request-Line = Method       SP Request-URI SP HTTP-Version  CRLF
    Response:   Status-Line  = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```    
```bash
    $ curl -i http://www.google.com
```
[Compare the response first-line with the HTTP spec.]

Let's begin to turn our server into a "real HTTP server" (We will leave the client alone for now). TO-DO...
* Fix the "recv(10000)" hack.
* Add proper handling of an HTTP GET request.


Fixing recv(10000)...
Recall that because our simple server.rb didn't know how to tell when a request was finished "requesting", we cheated and said, "Let's just read whatever is there, or 10,000 bytes, whichever comes first, hope that's good enough".  But that's not very good service...

Now that we know we're implementing HTTP, we should have some guidance.  Does the HTTP spec tell us when a GET request is finished?

Takes a little digging into the spec, but there is a nugget in section 4.3 that shines light:

    4.3 Message Body - " ... The presence of a message-body in a request is signaled by the inclusion of a Content-Length or Transfer-Encoding header field in the request's message-headers."

So, if there's no *"Content-Length"* header, then a message-body is not present.  Awesome!

*(You can go deep here, by asking "Well, COULD a GET request ever contain a message body?"  This post is an example demonstrating that people really do go back to the spec to answer such questions:  https://stackoverflow.com/questions/978061/http-get-with-request-body   The short answer is Yes, you can put a message-body in a GET request; and NO, you should never actually do so.)*


For our very simple HTTP server, let's make the simplifying assumption that a GET request has no message body--AND, we'll also assume that every request is a GET request (that is, we're not checking whether the first line starts with "GET", and we're not checking for Content-Length header).

This means that if our server sees a CRLF by itself...aHA, the request is complete!  Send the response and go on.

    $ ruby server.2.recv-replaced.rb

    $ curl -i http://localhost:8080

OK, that works.

Next step in a "real HTTP server":  Return a valid HTTP response.

Its format looks just like a request, except for the first line:

    Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF


    $ ruby server.3.valid-http-response.rb

[Small digression...]
* On the client side: We'll be using an existing HTTP client: The web browser and/or cURL.  BUT...
* Can we hit an HTTP server with our home-builtclient?  Let's try...[Anybody know of an HTTP server we could use?]
* In client.rb, change "localhost" to e.g., "google.com".

**Exercise**
For the client, do what we did to the server:  Teach client.rb to send a valid HTTP GET request to server.rb (no cheating by using an HTTP library!).   Can your client get a valid HTTP response back from http://www.google.com and print it out to the console?



We've come a long way...What have we learned?

1. Starting from a relatively brainless one-way server that knows nothing about HTTP, we now have a server that takes HTTP requests (for now, it assumes that they are GET requests) and returns valid HTTP responses.
1. We got some practice reading the HTTP 1.1 spec, where we saw some of how HTTP *must* work, and also a bit about how it *should* work.

What next?
* Routing - What if we started paying attention to the Request-URI in the HTTP header?  What if we also started paying attention to the "Method" part of the HTTP message?
* Handling GET parameters - Everything that comes after the host:port
* Handling a POST method.
* Handling POST parameters - Reading the query params from the body of the request.


## Version 4 - Server with simple HTTP routing
**Goal** - Understand what HTTP request routing is.

**Objective** - Based on the request URI's path, decide whether to return "Hello, world" or "Goodbye, world".

[Discuss, based on what we see in the HTTP 1.1. spec, what our server needs to do.]

**Exercise**
* Update server.rb to handle a path-based route.


## Version 5 - Server with Parameter handling
**Goal** - Understand how params are (typically) passed

**Objective** - In the place of "world", return the value of the request's 'name' parameter, e.g., "Hello, John".

**Exercise**
* Update server.rb to process a GET request with a name=<value> param, and return a valid HTTP response.
* Hint: Look at the HTTP 1.1 spec, section 5, which defines a Request.
* "Extra Credit": Note what is and is not in the "Request-URI" definition.  Notably, look at abs_path in 5.1.2.  Is the "name=value[&name=value...]" format defined in the HTTP 1.1. spec?



## Version 6 - Server that handles a POST method
**Goals**
* Gain experience with using a spec to guide design choices.
* Understand why we let other people write HTTP request-response code (e.g., buffering mode headaches)

**Objective** - Receive a POST request from cURL with parameters, and successfully read them from the body.

This line should be successfully processed by the server:
    $ curl -d'name=Bob&place=Chicago' -XPOST -H "Content-Length: 22"  http://localhost:8080

[Look at POST definition in HTTP spec, discuss how it differs from GET.]

**Exercise**
* Modify server.rb to read the parameter data in the body of the POST request.

Discuss the results (e.g. server.first-attempt-at-POST.rb).  Why might you get "recv for buffered IO (IOError)"?

**Exercise**
* Use the library methods in 'lib/unbuffered.rb' to read header lines and the body. (require '../lib/unbuffered')
* Bonus: Return an HTTP response with HTML that uses the parameters: "Hi NAME, welcome to PLACE!", where NAME and PLACE have the values of the POST'd parameters.
(One solution is in 'server.second-attempt-at-POST.rb'.)

**Exercise**
* Have your server respond with the contents of form.html on a 'GET /' request (from Chrome).
* Modify your server to handle the parameter format that Chrome sends when you click 'Submit' on the form.
* Send "Hi NAME" Response as previously, but also include a "Back" link that returns you to the form.
(One solution is in 'server.3rd.respond-with-form.rb'.)
(A better solution is in 'server.4th.respond-with-form.rb'.  Try diff'ing the two.)


## Version 7 - Server that handles a request header
**Goal** - Hands-on experience with processing request headers.

**Objective** - Receive a POST request (e.g. /user/login) with an authorization header, return "Hello <param>, you are logged in as <username-in-header>" (or "Not authorized" if wrong or missing header value).

[TODO] - Explore the similarities and diffs between request and response headers.



## Version 8 - Simple Rack server
**Goal** - Appreciate what an interface between Ruby framework and Ruby-compatible webserver does for you.

**Objective** - Implement what we've done so far as a Rack server.

Look at and run server.1.simplest-rack.rb.
How does this compare to our hand-built HTTP server?
* Fewer lines of code.
* More capability.  How so?...
  - For example: Try hitting it with a POST request, using curl.  [Returns 411 "Length required"].
  That's pretty cool!  It implements this "4.4 Message Length" recommendation in RFC2616:

     If a request contains a message-body and a Content-Length is not given,
      the server SHOULD respond with 400 (bad request) if it cannot
      determine the length of the message, or with 411 (length required) if
      it wishes to insist on receiving a valid Content-Length.

(Actually, this recommendation technically doesn't apply, since our request does not contain a message-body. In fact, I can't find anywhere that the HTTP spec requires a Content-Length header for POST with no message-body.  Can you?  But regardless, the Rack server does require the Content-Length header!)

Let's pass a request header:
    $ curl -i -XPOST http://localhost:8080 -H "Content-Length:0"

**Exercise**
* Use Rack::Request(env) to examine the request.

More Rack - Let's do something a little fancier.  Let's use actual named Ruby classes, instead of an anonymous class.

server.2.pass-a-named-class.rb

Next step - Rack provides wrappers for request (env) and response (the triplet), as in this next server example...

server.3.with-request-and-response-wrapper-classes.rb


## Version 9 - Rack server with middleware
**Goal** - Begin to understand middleware.

**Objective** - Create a layer of middleware and add it to a Rack server.

From https://www.amberbit.com/blog/2011/07/13/introduction-to-rack-middleware/...

Rack is used to group and order modules, which are usually Ruby classes, and specify dependencies between them. Rack::Builder puts these modules on top of each other, creating a stack-like structure of the final web application.


    $ bundle exec rackup config.ru  # Render a lobster!

    $ bundle exec rackup config.with_footer.ru  # Render a lobster with a shrimp footer!


## Version 10 - Very simple Sinatra server - a micro-framework
**Goal** - Distinguish Sinatra from Rack

**Objective** - Get a basic Sinatra app up and running.

What does Sinatra have that Rack doesn't?
* a DSL - e.g., "Method" methods - get, put, post, ...
* View templates

