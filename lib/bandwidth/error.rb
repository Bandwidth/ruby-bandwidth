module Bandwidth
  ERROR_PATH = 'errors'
  # The User Errors resource lets you see information about errors that happened in your API calls and during applications callbacks.
  class Error
    extend ClientWrapper

    # Gets information about one user error
    # @param client [Client] optional client instance to make requests
    # @param id [String] if of error
    # @return [Hash] error information
    # @example
    #   err = Error.get(client, "id")
    def self.get(client, id)
      client.make_request(:get, client.concat_user_path("#{ERROR_PATH}/#{id}"))[0]
    end
    wrap_client_arg :get

    # Gets all the user errors for a user
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] query options
    # @return [LazyEnumerator] list of errors
    # @example
    #   errors = Error.list(client)
    def self.list(client, query = nil)
      get_data = lambda do
        client.make_request(:get, client.concat_user_path(ERROR_PATH), query)
      end
      LazyEnumerator.new(get_data, client)
    end
    wrap_client_arg :list
  end
end
