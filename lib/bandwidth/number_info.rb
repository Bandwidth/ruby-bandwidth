require 'uri'

module Bandwidth
  NUMBERINFO_PATH = 'phoneNumbers/numberInfo'
  class NumberInfo
    extend ClientWrapper

    def self.get(client, number)
      client.make_request(:get, "#{NUMBERINFO_PATH}/#{URI.encode(number)}")[0]
    end
    wrap_client_arg :get
  end
end
