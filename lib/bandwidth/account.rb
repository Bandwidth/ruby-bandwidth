module Bandwidth
  ACCOUNT_PATH = 'account'
  class Account
    def Account.get(client = nil)
      client = Client.new() unless client
      client.make_request(:get, client.concat_user_path(ACCOUNT_PATH))
    end

    def Account.get_transactions(client=nil, query={})
      if client && !client.is_a?(Client)
        query = client
        client = nil
      end
      client = Client.new() unless client
      client.make_request(:get, client.concat_user_path(ACCOUNT_PATH + "/transactions"), query)
    end
  end
end
