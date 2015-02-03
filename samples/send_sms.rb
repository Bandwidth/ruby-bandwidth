# This is a demo of sending of sms

require "ruby-bandwidth"

Client = Bandwidth::Client
Message = Bandwidth::Message

# Fill these options before run this demo
Client.global_options = {:user_id => "", :api_token => "", :api_secret => ""}
from = "+1" #your number on catapult
to = "+1" #any number which can receive a message


message = Message.create({:from => from, :to => to, :text => "Hello there"})
puts("Your message id is #{message[:id]}")

