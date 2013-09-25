module Bandwidth
  class Types
    class Transaction
      include Instance

      attribute :id
      attribute :time, Time
      attribute :amount, Float
      attribute :type
      attribute :units
      attribute :product_type
      attribute :number
    end
  end
end
