# This is a demo of making of call

require "ruby-bandwidth"

Client = Bandwidth::Client
Call = Bandwidth::Call

# Fill these options before run this demo
Client.global_options = {:user_id => "", :api_token => "", :api_secret => ""}
from = "+1" #your number on catapult
to = "+1" #any number which can receive a call


call = Call.create({:from => from, :to => to})
puts("Your call id is #{call.id}")

