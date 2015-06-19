module Bandwidth
  module Errors
    # Generic error class
    class GenericError < StandardError
      # @return [String] Error code
      attr_reader :code

      def initialize code, message
        super message
        @code = code
      end
    end

    #  Missing Credentials error  class
    class MissingCredentialsError < StandardError

      def initialize
        super """
        Missing credentials.
        Use Bandwidth::Client.new(<userId>, <apiToken>, <apiSecret>) or Bandwidth::Client.global_options to set up them.
        """
      end
    end
  end
end
