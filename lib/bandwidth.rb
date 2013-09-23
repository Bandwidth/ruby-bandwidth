require 'faraday'
require 'json'

require 'bandwidth/hash_with_underscore_access'
require 'bandwidth/hash_camelizer'

require "bandwidth/account_api"
require "bandwidth/connection"
require "bandwidth/version"

module Bandwidth
  class << self
    def new user_id, token, secret
      Bandwidth::Connection.new user_id, token, secret
    end
  end
end
