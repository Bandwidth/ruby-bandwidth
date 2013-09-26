module Bandwidth
  class Types
    class Account
      include Instance

      # @return [Float] Your account balance in dollars
      attribute :balance, Float

      # @return [String] The type of account configured for your user
      attribute :account_type
    end
  end
end
