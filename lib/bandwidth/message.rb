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
    # @param data [Hash|Array] options of new message or list of messages
    # @return [Hash] created message or statuses of list of messages
    # @example
    #   message = Message.create(client, {:from=>"from", :to=>"to", :text=>"text"})
    #   statuses = Message.create(client, [{:from=>"from1", :to=>"to1", :text=>"text1"}, {:from=>"from2", :to=>"to2", :text=>"text2"}])
    def self.create(client, data)
      res = client.make_request(:post, client.concat_user_path(MESSAGE_PATH), data)
      if data.is_a? Array
        res[0].map do |i|
          if i[:result] == "error"
            {:error => StandardError.new(i[:error][:message])}
          else
            items = (i[:location] || '').split('/')
            if items.size < 2 then  {:error =>  StandardError.new('Missing id in the location header')} else {:id => items.last} end
          end
        end
      else
        headers = res[1]
        id = Client.get_id_from_location_header(headers[:location])
        self.get(client, id)
      end
    end
    wrap_client_arg :create

    # Redact the text of a previously sent message
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of message
    # @param data [Hash] data to change
    # @example
    #   Message.patch(client, "id" {:text=>""})
    def self.patch(client, id, data)
      client.make_request(:patch, client.concat_user_path("#{MESSAGE_PATH}/#{id}"), data)[0]
    end
    wrap_client_arg :patch
  end
end
