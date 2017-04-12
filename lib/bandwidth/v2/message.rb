module Bandwidth
  module V2
    MESSAGE_PATH = 'messages'
    # The Messages resource lets you send SMS text messages and view messages that were previously sent or received.
    class Message
      extend ClientWrapper
      # Send text messages
      # @param client [Client] optional client instance to make requests
      # @param data [Hash] options of new message or list of messages
      # @return [Hash] created message or statuses of list of messages
      # @example
      #   message = Message.create(client, {:from=>"from", :to=>["to"], :text=>"text"})
      def self.create(client, data)
        client.make_request(:post, client.concat_user_path(MESSAGE_PATH), data, 'v2')[0]
      end
      wrap_client_arg :create
    end
  end
end
