module Bandwidth
  ACCOUNT_PATH = 'account'
  class Account
    extend ClientWrapper

    def self.get(client)
      client.make_request(:get, client.concat_user_path(ACCOUNT_PATH))[0]
    end
    wrap_client_arg :get

    def self.get_transactions(client, query={})
      client.make_request(:get, client.concat_user_path(ACCOUNT_PATH + "/transactions"), query)[0]
    end
    wrap_client_arg :get_transactions
  end
end
