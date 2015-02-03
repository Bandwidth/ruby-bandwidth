# This is a demo of searching and allocating a phone number

require "ruby-bandwidth"

Client = Bandwidth::Client
AvailableNumber = Bandwidth::AvailableNumber
PhoneNumber = Bandwidth::PhoneNumber

# Fill these options before run this demo
Client.global_options = {:user_id => "", :api_token => "", :api_secret => ""}

numbers = AvailableNumber.search_local({:city => "Cary", :state => "NC", :quantity => 3})
puts("Found numbers: #{(numbers.map {|n| n[:number]}).join(', ')}")
number = PhoneNumber.create({:number => numbers[0][:number]})
puts("Now you are owner of number #{number.number} (id #{number.id})")

