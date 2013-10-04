module Bandwidth
  module Types
    class Message
      include Instance

      # @return [String] A unique identifier for the message
      attribute :id

      # @return [String] Message direction. One of:
      #   in: A message that came from the telephone network to one of your numbers (an "inbound" message)
      #   out: A message that was sent from one of your numbers to the telephone network (an "outbound" message)
      attribute :direction

      # @return [String] The message sender's telephone number
      attribute :from

      # @return [String] The message recipient's telephone number
      attribute :to

      # @return [String] One of the message states
      # @see API::Messages::States possible return values
      attribute :state

      # @return [Time] The time the transaction was processed
      attribute :time, Time

      # @return [String] The message contents
      attribute :text
    end
  end
end
