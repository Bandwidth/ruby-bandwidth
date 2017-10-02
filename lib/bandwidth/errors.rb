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

    # Dashboard error class
    class GenericIrisError < StandardError
      # @return [String] Error code
      attr_reader :code

      # @return [String] Http status code
      attr_reader :http_status

      # @api private
      def initialize code, message, http_status
        super message
        @code = code
        @http_status = http_status
      end
    end

    # Agregate error class
    class AgregateError < StandardError
      # @return [Array] errors
      attr_reader :errors

      # @api private
      def initialize errorss
        super "Multiple errors"
        @errors = errors
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
