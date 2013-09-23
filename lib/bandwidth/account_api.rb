module Bandwidth
  module AccountAPI
    def account
      account = get 'account'
      account['balance'] = account['balance'].to_f

      HashWithUnderscoreAccess.new account
    end

    def transactions
      transactions = get 'account/transactions'

      transactions.map do |transaction|
        transaction['amount'] = transaction['amount'].to_f
        HashWithUnderscoreAccess.new transaction
      end
    end
  end
end
