# This is a demo of making of call

require_relative "../lib/ruby-bandwidth.rb" # use require "ruby-bandwidth" in real projects

Client = Bandwidth::Client
Call = Bandwidth::Call

# Fill these options before run this demo
Client.global_options = {:user_id => "u-rzmdaw5mxl4jrme56jyhe5i", :api_token => "t-mvpixlx2emztxuov4x3kf4y", :api_secret => "x5v2dmfttswkiqxlcltisdyjq2w52u5vogzp6ki"}
from = "+19196940343" #your number on catapult
to = "+19196940040" #any number which can receive a call


call = Call.create({:from => from, :to => to})
puts("Your call id is #{call.id}")

