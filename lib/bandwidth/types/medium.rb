module Bandwidth
  module Types
    class Medium
      include Instance

      # @return [Integer] Medium length in bytes
      attribute :content_length, Integer

      # @return [String] Medium name
      attribute :media_name
    end
  end
end
