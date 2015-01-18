require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start()


require 'bandwidth'
require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


RSpec.configure do |conf|
  include Bandwidth
end

module Helper
  def self.get_client()
    StubbedClient.new('userId', 'token', 'secret')
  end
end

class StubbedClient < Bandwidth::Client
  def initialize (user_id = nil, api_token = nil, api_secret = nil, api_endpoint = 'https://api.catapult.inetwork.com', api_version = 'v1')
    super(user_id, api_token, api_secret, api_endpoint, api_version)
    @stubs = Faraday::Adapter::Test::Stubs.new()
    create_connection = @create_connection
    @create_connection = lambda{||
      connection = create_connection.call()
      connection.adapter(:test, @stubs)
      connection
    }
  end
 def stubs()
  @stubs
 end
end

