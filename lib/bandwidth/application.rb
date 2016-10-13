module Bandwidth
  APPLICATION_PATH = 'applications'
  # The Applications resource lets you define call and message handling applications
  class Application
    extend ClientWrapper
    include ApiItem

    # Get information about an application
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of application
    # @return [Application] application information
    # @example
    #   app = Application.get(client, "id")
    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{APPLICATION_PATH}/#{id}"))[0]
      Application.new(item, client)
    end
    wrap_client_arg :get

    # Get a list of your applications
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] optional hash with query options
    # @return [Enumerator] array of Application instances
    # @example
    #   list = Application.list(client)
    def self.list(client, query = nil)
      get_data = lambda do
        items, headers = client.make_request(:get, client.concat_user_path(APPLICATION_PATH), query)
        items = items.map do |item|
          Application.new(item, client)
        end
        [items, headers]
      end
      LazyEnumerator.new(get_data, client)
    end
    wrap_client_arg :list

    # Create an application
    # @param client [Client] optional client instance to make requests
    # @param data [Hash] hash of values to create application
    # @return [LazyInstance] created application
    # @example
    #   app = Application.create(client, :name => "new app")
    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(APPLICATION_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      LazyInstance.new(id, lambda { self.get(client, id) })
    end
    wrap_client_arg :create

    # Update an application
    # @param data [Hash] changed data
    # @example
    #   app.update(:incoming_call_url => "http://host1")
    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{APPLICATION_PATH}/#{id}"), data)[0]
    end

    # Remove an application
    # @example
    #   app.delete()
    def delete()
      @client.make_request(:delete, @client.concat_user_path("#{APPLICATION_PATH}/#{id}"))[0]
    end

    alias_method :destroy, :delete
  end
end
