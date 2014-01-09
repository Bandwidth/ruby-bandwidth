module Bandwidth
  module Audio
    class File < Base
      # Sentence that can be used in speak functions
      #
      # @param [String] file_url Audio file url
      #
      def initialize file_url, options={}
        @options = options
        @file_url = file_url
      end

      # @api private
      def to_hash
        super.merge({fileUrl: @file_url})
      end
    end
  end
end
