module Bandwidth
  # Endpoint of domain
  class EndPoint
    include ApiItem
    attr_accessor :domain_id

    # Remove an endpoint from domain.
    # @example
    #   endpoint.delete()
    def delete()
      @client.make_request(:delete, @client.concat_user_path("#{DOMAIN_PATH}/#{@domain_id}/endpoints/#{id}"))[0]
    end

    alias_method :destroy, :delete
  end
end
