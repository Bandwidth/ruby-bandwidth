require 'uri'

module Bandwidth
  NUMBERINFO_PATH = 'phoneNumbers/numberInfo'
  # CNAM API allows the user to get the CNAM information of a particular number
  class NumberInfo
    extend ClientWrapper

    # Get the CNAM info of a number
    # @param client [Client] optional client instance to make requests
    # @param number [String] phone number
    # @return [Hash] found information about phone number
    # @example
    #   info = NumberInfo.get(client, "number")
    def self.get(client, number)
      client.make_request(:get, "#{NUMBERINFO_PATH}/#{URI.encode(number)}")[0]
    end
    wrap_client_arg :get
  end
end
