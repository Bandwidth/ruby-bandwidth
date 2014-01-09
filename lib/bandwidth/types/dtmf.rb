module Bandwidth
  module Types
    class DTMF
      include Instance

      # @return [String] A string of the digits pressed during the gather period, not including the terminating digit, in the order they were received. May be an empty string if no digits were received before the timeout
      attribute :digits

      # @return [String] One of these strings which indicates the final state of the gather operation:
      #   max-digits: The maximum number of digits were gathered
      #   terminating-digit: A terminating digit stopped the gather operation
      #   inter-digit-timeout: The configured number of seconds elapsed before a digit was read
      #   hung-up: The phone call ended before the normal termination criteria were satisfied
      attribute :state

      # @return [String] The terminating digit that ended the gather operation, if terminating digits were configured and one was pressed
      attribute :terminating_digit

      # @return [String] The tag string you sent with the gather request, if any
      attribute :tag
    end
  end
end
