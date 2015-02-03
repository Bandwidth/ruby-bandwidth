# This is a demo of creating and removing and application
# This sample calls method 'list' of user's resourses ans shows results on console
require_relative "../lib/ruby-bandwidth.rb" # use require "ruby-bandwidth" in real projects

Client = Bandwidth::Client

# Fill these options before run this demo
Client.global_options = {:user_id => "u-rzmdaw5mxl4jrme56jyhe5i", :api_token => "t-mvpixlx2emztxuov4x3kf4y", :api_secret => "x5v2dmfttswkiqxlcltisdyjq2w52u5vogzp6ki"}

def show(resource, title = nil)
  title = resource + "s" unless title
  puts("#{title}\n==================")
  begin
    type = Object.const_get("Bandwidth").const_get(resource)
    items = type.send("list").map {|i| if i.class.method_defined?(:to_data) then i.to_data() else i end }
    items.each {|i| puts(i)}
  rescue Exception => e
    puts "Error: #{e.message}"
  end
  puts("\n")
end

show "Application"
show "Bridge"
show "Call"
show "Domain"
show "Error"
show "Media", "Files"
show "Message"
show "PhoneNumber", "Numbers"
show "Recording"


