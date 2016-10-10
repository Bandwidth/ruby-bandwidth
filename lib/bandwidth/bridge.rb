module Bandwidth
  BRIDGE_PATH = 'bridges'

  # Bridges resource. Bridge two calls allowing two way audio between them.
  class Bridge
    extend ClientWrapper
    include ApiItem

    # Get information about an specific bridge
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of bridge
    # @return [Bridge] Bridge instance
    # @example
    #   bridge = Bridge.get(client, "id")
    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{BRIDGE_PATH}/#{id}"))[0]
      Bridge.new(item, client)
    end
    wrap_client_arg :get

    # Get a list of previous bridges
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] hash with query parameters
    # @return [Array] array of Bridge instances
    # @example
    #   list = Bridge.list(client)
    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(BRIDGE_PATH), query)[0].map do |item|
        Bridge.new(item, client)
      end
    end
    wrap_client_arg :list

    # Create a bridge
    # @param client [Client] optional client instance to make requests
    # @param data  [Hash] data to create a bridge
    # @return [Bridge] created bridge
    # @example
    #   bridge = Bridge.create(client, {:call_ids => ["id1", "id2"]})
    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(BRIDGE_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create

    # Update a bridge
    # @param data [Hash] changed data
    # @example
    #   bridge.updatei(:bridge_audio => true, :call_ids => ["id3"]) #add a call to the bridge
    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{BRIDGE_PATH}/#{id}"), data)[0]
    end

    # Play an audio or speak a sentence in a bridge
    # @param data [Hash] options for request
    # @example
    #   bridge.play_audio :file_url => "http://host1"
    def play_audio(data)
      @client.make_request(:post, @client.concat_user_path("#{BRIDGE_PATH}/#{id}/audio"), data)[0]
    end

    # Return calls of current bridge
    # @return [Array] array of Call instances
    # @example
    #   calls = bridge.get_calls()
    def get_calls()
      @client.make_request(:get, @client.concat_user_path("#{BRIDGE_PATH}/#{id}/calls"))[0].map do |item|
        Call.new(item, @client)
      end
    end
  end
end
