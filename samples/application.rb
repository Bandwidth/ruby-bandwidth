# This is a demo of creating and removing and application

require_relative "../lib/ruby-bandwidth.rb" # use require "ruby-bandwidth" in real projects

Client = Bandwidth::Client
Application = Bandwidth::Application

# Fill these options before run this demo
Client.global_options = {:user_id => "u-rzmdaw5mxl4jrme56jyhe5i", :api_token => "t-mvpixlx2emztxuov4x3kf4y", :api_secret => "x5v2dmfttswkiqxlcltisdyjq2w52u5vogzp6ki"}

app = Application.create({:name => "Demo Application from samples", :incoming_call_url => "http://localhost"})
puts("Created application name is #{app.name}")
app.delete()
puts("The application has been removed")

