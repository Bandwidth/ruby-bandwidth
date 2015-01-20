module Bandwidth
  AVAILABLE_NUMBER_PATH = 'availableNumbers'
  class AvailableNumber
    extend ClientWrapper

    def self.search_toll_free(client, query = nil)
      client.make_request(:get, client.concat_user_path("#{AVAILABLE_NUMBER_PATH}/tollFree"), query)[0]
    end
    wrap_client_arg :search_toll_free

    def self.search_local(client, query = nil)
      client.make_request(:get, client.concat_user_path("#{AVAILABLE_NUMBER_PATH}/local"), query)[0]
    end
    wrap_client_arg :search_local
  end
end
