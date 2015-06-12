module Bandwidth
  # Endpoint of domain
  class EndPoint
    include ApiItem
    attr_accessor :domain_id

    # Remove an endpoint from domain.
    # @example
    #   endpoint.delete()
    def delete()
      @client.make_request(:delete, @client.concat_user_path("#{DOMAIN_PATH}/#{domain_id}/endpoints/#{id}"))[0]
    end

    alias_method :destroy, :delete


    # Create auth token.
    # @example
    #   token = endpoint.create_auth_token()
    def create_auth_token()
      @client.make_request(:post, @client.concat_user_path("#{DOMAIN_PATH}/#{domain_id}/endpoints/#{id}/tokens"))[0]
    end

    # Delete auth token.
    # @example
    #   endpoint.delete_auth_token('token')
    def delete_auth_token(token)
      @client.make_request(:delete, @client.concat_user_path("#{DOMAIN_PATH}/#{domain_id}/endpoints/#{id}/tokens/#{token}"))[0]
    end
  end
end
