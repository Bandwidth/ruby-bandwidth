module Bandwidth
  module Types
    class PhoneNumber
      include Instance

      # @return [String] The phone number in E.164 format (+19192972393)
      attribute :number

      # @return [String] The phone number in human national format ((919) 297-2393)
      attribute :national_number

      # @return [String] The matched pattern in case of pattern search ("          2 9 ")
      attribute :pattern_match

      # @return [Float] Monthly price
      attribute :price, Float
    end

    class LocalPhoneNumber < PhoneNumber
      # @return [String] The city
      attribute :city

      # @return [String] The state
      attribute :state
    end
  end
end
