module Bandwidth
  module API
    module Messages

      # Send text messages
      #
      # @param [String] from Phone number to send message from
      # @param [String] to Phone number to send message to
      # @param [String] text Message text
      #
      # @return [String] Message id
      #
      # @example
      #   message_id = bandwidth.send_message "+19195551212", "+13125556666", "Good morning, this is a test message"
      #
      def send_message from, to, text
        _body, headers = post 'messages', from: from, to: to, text: text
        headers['location'].match(/[^\/]+$/)[0]
      end

      # Get a message
      #
      # @param [String] message_id Message id
      #
      # @return [<Types::Message>]
      #
      # @example
      #   message = bandwidth.message message_id
      #
      def message message_id
        body, _headers = get "messages/#{message_id}"
        Types::Message.new body
      end

      # Get a list of messages
      #
      # @param [Hash] options The options to create a request with
      # @option options [String] :from Filter by sender
      # @option options [String] :to Filter by recipient
      #
      # @return [Array<Types::Message>]
      #
      # @example Getting a list of messages
      #   bandwidth.messages # => [#<Message:0xb642ffc>, #<Message:0xb642fe8>]
      #
      #   message.direction # => "out"
      #   message.from # => "+19195551212"
      #   message.to # => "+13125556666"
      #   message.state # => "sent"
      #   message.time # => 2012-10-05 20:38:11 UTC
      #   message.text # => "Good morning, this is a test message"
      #
      # @example Filter by time sender
      #   messages = bandwidth.messages from: "+19195551212", to:"+13125556666" # => [#<Message:0xa8526e0>, #<Message:0xa85ee7c>]
      #
      def messages options = {}
        messages, _headers = get 'messages', options

        messages.map do |message|
          Types::Message.new message
        end
      end

      module States
        # @return [String] The message was received
        RECEIVED = 'received'.freeze

        # @return [String] The message is waiting in queue and will be sent soon
        QUEUED = 'queued'.freeze

        # @return [String] The message was removed from queue and is being sent
        SENDING = 'sending'.freeze

        # @return [String] The message was sent successfully
        SENT = 'sent'.freeze

        # @return [String] There was an error sending or receiving a message (check your user errors for details)Transaction Types
        ERROR = 'error'.freeze
      end
    end
  end
end
