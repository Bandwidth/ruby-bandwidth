module Bandwidth
  ACCOUNT_PATH = 'account'
  # Account API allows you to retrieve your current balance, transaction list, account type and all elements related to your platform account.
  class Account
    extend ClientWrapper

    # Get information about your account
    # @param client [Client] optional client instance to make requests
    # @return [Hash] account information
    # @example
    #   account = Account.get(client)
    def self.get(client)
      client.make_request(:get, client.concat_user_path(ACCOUNT_PATH))[0]
    end
    wrap_client_arg :get

    # Get a list of the transactions made to your account
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] optional query hash
    # @return [Enumerator] list of transactions
    # @example
    #   transactions = Account.get_transactions(client)
    def self.get_transactions(client, query={})
      get_data = lambda { client.make_request(:get, client.concat_user_path(ACCOUNT_PATH + "/transactions"), query) }
      LazyEnumerator.new(get_data, client)
    end
    wrap_client_arg :get_transactions
  end
end
