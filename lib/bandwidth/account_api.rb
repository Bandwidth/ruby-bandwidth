module Bandwidth
  module AccountAPI
    def account
      account = get 'account'
      Account.new account['balance'].to_f, account['accountType']
    end
  end

  class Account
    attr_reader :balance, :account_type

    def initialize balance, account_type
      @balance, @account_type = balance, account_type
    end
  end
end
