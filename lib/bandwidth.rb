require "bandwidth/types/instance"
require "bandwidth/types/account"
require "bandwidth/types/transaction"
require "bandwidth/types/message"
require "bandwidth/types/phone_number"
require "bandwidth/types/call"
require "bandwidth/types/dtmf"
require "bandwidth/types/record"
require "bandwidth/types/medium"
require "bandwidth/types/bridge"
require "bandwidth/types/conference"
require "bandwidth/types/conference_member"

require "bandwidth/audio/base"
require "bandwidth/audio/file"
require "bandwidth/audio/sentence"

require "bandwidth/errors/generic_error"
require "bandwidth/errors/restricted_number"

require "bandwidth/lazy_array"

require "bandwidth/api/account"
require "bandwidth/api/messages"
require "bandwidth/api/available_numbers"
require "bandwidth/api/phone_numbers"
require "bandwidth/api/calls"
require "bandwidth/api/media"
require "bandwidth/api/records"
require "bandwidth/api/bridges"
require "bandwidth/api/conferences"

require "bandwidth/connection"
require "bandwidth/version"

module Bandwidth

  # Connect to Bandwidth API
  #
  # @param user_id [String] Your Bandwidth User Id
  # @param token [String] Your Bandwidth API Token
  # @param secret [String] Your Bandwidth API Secret
  #
  # @return [Connection] Bandwidth API access object
  #
  # @example Creating an API connection
  #   USER_ID = "u-ku5k3kzhbf4nligdgweuqie" # Your user id
  #   TOKEN  = "t-apseoipfjscawnjpraalksd" # Your account token
  #   SECRET = "6db9531b2794663d75454fb42476ddcb0215f28c" # Your secret
  #
  #   bandwidth = Bandwidth.new USER_ID, TOKEN, SECRET
  #
  def self.new user_id, token, secret
    Bandwidth::Connection.new user_id, token, secret
  end
end
