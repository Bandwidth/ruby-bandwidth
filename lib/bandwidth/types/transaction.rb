module Bandwidth
  class Types
    class Transaction
      include Instance

      # @return [String] A unique identifier for the transaction
      attribute :id

      # @return [Time] The time the transaction was processed
      attribute :time, Time

      # @return [Float] The transaction amount in dollars
      attribute :amount, Float

      # @return [String] The type of transaction
      # @see API::Account::TransactionTypes possible return values
      attribute :type

      # @return [String] The number of product units the transaction charged or credited
      attribute :units

      # @return [String] The product the transaction was related to (not all transactions are related to a product)
      # @see API::Account::ProductTypes possible return values
      attribute :product_type

      # @return [String] The phone number the transaction was related to (not all transactions are related to a phone number)
      attribute :number
    end
  end
end
