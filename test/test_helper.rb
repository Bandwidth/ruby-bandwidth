require 'minitest/autorun'
require 'minitest/pride'

require 'bundler'
Bundler.require

require_relative '../lib/bandwidth.rb'

module Bandwidth
  class StubbedConnection < Connection
    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.adapter :test, @stubs
      end
    end

    def url path
      path
    end

    def stub
      @stubs ||= Faraday::Adapter::Test::Stubs.new
    end
  end
end
