require_relative "bandwidth/types/instance"
require_relative "bandwidth/types/account"
require_relative "bandwidth/types/transaction"
require_relative "bandwidth/types/message"
require_relative "bandwidth/types/phone_number"
require_relative "bandwidth/types/call"
require_relative "bandwidth/types/dtmf"
require_relative "bandwidth/types/record"
require_relative "bandwidth/types/medium"
require_relative "bandwidth/types/bridge"
require_relative "bandwidth/types/conference"
require_relative "bandwidth/types/conference_member"

require_relative "bandwidth/audio/base"
require_relative "bandwidth/audio/file"
require_relative "bandwidth/audio/sentence"

require_relative "bandwidth/errors/generic_error"
require_relative "bandwidth/errors/restricted_number"

require_relative "bandwidth/lazy_array"

require_relative "bandwidth/api/account"
require_relative "bandwidth/api/messages"
require_relative "bandwidth/api/available_numbers"
require_relative "bandwidth/api/phone_numbers"
require_relative "bandwidth/api/calls"
require_relative "bandwidth/api/media"
require_relative "bandwidth/api/records"
require_relative "bandwidth/api/bridges"
require_relative "bandwidth/api/conferences"

require_relative "bandwidth/connection"
require_relative "bandwidth/version"

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
