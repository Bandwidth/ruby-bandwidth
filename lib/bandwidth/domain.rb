module Bandwidth
  DOMAIN_PATH = 'domains'
  #The Domain resource allows you create domains, add endpoints to it.
  class Domain
    extend ClientWrapper
    include ApiItem

    # Get created domains
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of a domain
    # @return [Array] list of domains
    # @example
    #   domains = Domain.list(client)
    def self.list(client)
      client.make_request(:get, client.concat_user_path(DOMAIN_PATH))[0].map do |item|
        Domain.new(item, client)
      end
    end
    wrap_client_arg :list

    # Create a domain.
    # @param client [Client] optional client instance to make requests
    # @param data [Hash] data to create a domain
    # @return [Domain] created domain
    # @example
    #   domain = Domain.create(client, :name => "domain1")
    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(DOMAIN_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      Domain.new(:id => id, :name => data[:name], :description => data[:description])
    end
    wrap_client_arg :create

    # Delete a domain
    # @example
    #   domain.delete()
    def delete()
      @client.make_request(:delete, @client.concat_user_path("#{DOMAIN_PATH}/#{id}"))[0]
    end

    alias_method :destroy, :delete

    # Add a endpoint to a domain.
    # @param data [Hash] data to add endpoint to a domain
    # @return [EndPoint] created endpoint
    # @example
    #   endpoint = domain.create_endpoint(:name=>"name", :application_id => "id")
    def create_endpoint(data)
      headers = @client.make_request(:post, @client.concat_user_path("#{DOMAIN_PATH}/#{id}/endpoints"), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      get_endpoint(id)
    end

    # Retrieve information about an endpoint
    # @param endpoint_id [String] id of endpoint
    # @return [EndPoint] endpoint information
    # @example
    #   endpoint = domain.get_endpoint("id")
    def get_endpoint(endpoint_id)
      endpoint = EndPoint.new(@client.make_request(:get, @client.concat_user_path("#{DOMAIN_PATH}/#{id}/endpoints/#{endpoint_id}"))[0],
                           @client)
      endpoint.domain_id = id
      endpoint
    end

    # List all endpoints from a domain
    # @return [Array] array of EndPoint instances
    # @example
    #   endpoints = domain.get_endpoints()
    def get_endpoints()
      @client.make_request(:get, @client.concat_user_path("#{DOMAIN_PATH}/#{id}/endpoints"))[0].map do |i|
        endpoint = EndPoint.new(i, @client)
        endpoint.domain_id = id
        endpoint
      end
    end

    # Delete an endpoint
    # @example
    #   domain.delete_endpoint("id")
    def delete_endpoint(endpoint_id)
      endpoint = EndPoint.new({:id => endpoint_id}, @client)
      endpoint.domain_id = id
      endpoint.delete()
    end

    alias_method :destroy_endpoint, :delete_endpoint
  end
end
