module Bandwidth
  MESSAGE_PATH = 'messages'
  # The Messages resource lets you send SMS text messages and view messages that were previously sent or received.
  class Message
    extend ClientWrapper

    # Get information about a message that was sent or received
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of message
    # @return [Hash] message information
    # @example
    #   message = Message.get(client, "id")
    def self.get(client, id)
      client.make_request(:get, client.concat_user_path("#{MESSAGE_PATH}/#{id}"))[0]
    end
    wrap_client_arg :get

    # Get a list of previous messages that were sent or received
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] query options
    # @return [Array] list of messages
    # @example
    #   messages = Message.list(client)
    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(MESSAGE_PATH), query)[0]
    end
    wrap_client_arg :list

    # Send text messages
    # @param client [Client] optional client instance to make requests
    # @param data [Hash] options of new message
    # @return [Hash] created message
    # @example
    #   message = Message.create(client, {:from=>"from", :to=>"to", :text=>"text"})
    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(MESSAGE_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create
  end
end
