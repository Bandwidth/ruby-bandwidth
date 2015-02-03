# This is a demo of creating and removing and application

require "ruby-bandwidth"

Client = Bandwidth::Client
Application = Bandwidth::Application

# Fill these options before run this demo
Client.global_options = {:user_id => "", :api_token => "", :api_secret => ""}

app = Application.create({:name => "Demo Application from samples", :incoming_call_url => "http://localhost"})
puts("Created application name is #{app.name}")
app.delete()
puts("The application has been removed")

