# This is a demo of sending of mms and uploading file to the api server
require "ruby-bandwidth"

Client = Bandwidth::Client
Message = Bandwidth::Message
Media = Bandwidth::Media

# Fill these options before run this demo
Client.global_options = {:user_id => "", :api_token => "", :api_secret => ""}
from = "+1" #your number on catapult
to = "+1" #any number which can receive a message


# Upload image file if need
file = (Media.list().select {|f| f[:media_name] == "ruby_test.png"}).first
unless file
  Media.upload("ruby_test.png", File.open("./test.png", "r"), "image/png")
  file = (Media.list().select {|f| f[:media_name] == "ruby_test.png"}).first
end

#Sending this image as MMS
message = Message.create({:from => from, :to => to, :text => "Hello there", :media => [file[:content]]})
puts("Your message id is #{message[:id]}")

