module Bandwidth
  module Errors
    class GenericError < StandardError
      # @return [String] Error code
      attr_reader :code

      # @api private
      def initialize code, message
        super message
        @code = code
      end
    end
  end
end
