require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start()


require 'ruby-bandwidth'
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
    Client.new('userId', 'token', 'secret')
  end

  def self.setup_environment()
    Client.global_options[:user_id] = 'userId'
    Client.global_options[:api_token] = 'token'
    Client.global_options[:api_secret] = 'secret'
    @stubs = Faraday::Adapter::Test::Stubs.new()
  end

  def self.stubs()
    @stubs
  end

  def self.camelcase v
    case
      when v.is_a?(Array)
        v.map {|i| camelcase(i)}
      when v.is_a?(Hash)
        result = {}
        v.each do |k, val|
          result[k.to_s().camelcase(:lower)] = camelcase(val)
        end
        result
      else
        v
    end
  end

  def self.to_xml(verb)
    Xml::Response.new([verb]).to_xml()
  end
end

class  Bandwidth::Client
  alias_method :old_initialize, :initialize
  def initialize (user_id = nil, api_token = nil, api_secret = nil, api_endpoint = 'https://api.catapult.inetwork.com', api_version = 'v1')
    old_initialize(user_id, api_token, api_secret, api_endpoint, api_version)
    @stubs = if user_id  then  Faraday::Adapter::Test::Stubs.new() else Helper.stubs end
    @set_adapter = lambda{|faraday| faraday.adapter(:test, @stubs)}
  end
 def stubs()
  @stubs
 end
end

