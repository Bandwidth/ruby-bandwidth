module Bandwidth
  class Types
    class Account
      include Instance

      attribute :balance, Float
      attribute :account_type
    end
  end
end
