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

    # Update an endpoint
    # @param data [Hash] changed data
    # @example
    #   endpoint.update({:enabled => false})
    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{DOMAIN_PATH}/#{domain_id}/endpoints/#{id}"), data)[0]
    end



    # Create auth token.
    # @example
    #   token = endpoint.create_auth_token()
    def create_auth_token(expires = 86400)
      @client.make_request(:post, @client.concat_user_path("#{DOMAIN_PATH}/#{domain_id}/endpoints/#{id}/tokens"), {expires: expires})[0]
    end

    # Delete auth token.
    # @example
    #   endpoint.delete_auth_token('token')
    def delete_auth_token(token)
      @client.make_request(:delete, @client.concat_user_path("#{DOMAIN_PATH}/#{domain_id}/endpoints/#{id}/tokens/#{token}"))[0]
    end
  end
end
