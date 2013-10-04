module Bandwidth
  module Types
    class PhoneNumber
      include Instance

      attribute :number

      attribute :national_number

      attribute :pattern_match

      attribute :price, Float
    end

    class LocalPhoneNumber < PhoneNumber
      # FIXME: get rid of this duplication by adding some more complicated magic to Instance

      include Instance

      attribute :number

      attribute :national_number

      attribute :pattern_match

      attribute :price, Float

      attribute :city

      attribute :state
    end
  end
end
