require 'bandwidth/hash_camelizer'

require "bandwidth/types/instance"
require "bandwidth/types/account"
require "bandwidth/types/transaction"

require "bandwidth/api/account"

require "bandwidth/connection"
require "bandwidth/version"

module Bandwidth
  class << self
    def new user_id, token, secret
      Bandwidth::Connection.new user_id, token, secret
    end
  end
end
