# This is a demo of searching and allocating a phone number

require_relative "../lib/ruby-bandwidth.rb" # use require "ruby-bandwidth" in real projects

Client = Bandwidth::Client
AvailableNumber = Bandwidth::AvailableNumber
PhoneNumber = Bandwidth::PhoneNumber

# Fill these options before run this demo
Client.global_options = {:user_id => "u-rzmdaw5mxl4jrme56jyhe5i", :api_token => "t-mvpixlx2emztxuov4x3kf4y", :api_secret => "x5v2dmfttswkiqxlcltisdyjq2w52u5vogzp6ki"}

numbers = AvailableNumber.search_local({:city => "Cary", :state => "NC", :quantity => 3})
puts("Found numbers: #{(numbers.map {|n| n[:number]}).join(', ')}")
number = PhoneNumber.create({:number => numbers[0][:number]})
puts("Now you are owner of number #{number.number} (id #{number.id})")

