# This is a demo of sending of mms and uploading file to the api server
require_relative "../lib/ruby-bandwidth.rb" # use require "ruby-bandwidth" in real projects

Client = Bandwidth::Client
Message = Bandwidth::Message
Media = Bandwidth::Media

# Fill these options before run this demo
Client.global_options = {:user_id => "u-rzmdaw5mxl4jrme56jyhe5i", :api_token => "t-mvpixlx2emztxuov4x3kf4y", :api_secret => "x5v2dmfttswkiqxlcltisdyjq2w52u5vogzp6ki"}
from = "+19196940343" #your number on catapult
to = "+19196940040" #any number which can receive a message


# Upload image file if need
file = (Media.list().select {|f| f[:media_name] == "ruby_test.png"}).first
unless file
  Media.upload("ruby_test.png", File.open("./test.png", "r"), "image/png")
  file = (Media.list().select {|f| f[:media_name] == "ruby_test.png"}).first
end

#Sending this image as MMS
message = Message.create({:from => from, :to => to, :text => "Hello there", :media => [file[:content]]})
puts("Your message id is #{message[:id]}")

