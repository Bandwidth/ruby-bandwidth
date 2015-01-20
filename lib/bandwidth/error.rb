module Bandwidth
  ERROR_PATH = 'errors'
  class Error
    extend ClientWrapper

    def self.get(client, id)
      client.make_request(:get, client.concat_user_path("#{ERROR_PATH}/#{id}"))[0]
    end
    wrap_client_arg :get

    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(ERROR_PATH), query)[0]
    end
    wrap_client_arg :list
  end
end
