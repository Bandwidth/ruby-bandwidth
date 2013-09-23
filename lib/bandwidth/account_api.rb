require 'time'

module Bandwidth
  module AccountAPI
    def account
      account = get 'account'
      account['balance'] = account['balance'].to_f

      HashWithUnderscoreAccess.new account
    end

    CHARGE, PAYMENT, CREDIT, AUTO_RECHARGE = %w{charge payment credit auto-recharge}.map &:freeze

    def transactions params = {}
      params[:from_date] = params[:from_date].iso8601 if params[:from_date]
      params[:to_date] = params[:to_date].iso8601 if params[:to_date]

      transactions = get 'account/transactions', params

      transactions.map do |transaction|
        transaction['amount'] = transaction['amount'].to_f
        transaction['time'] = Time.parse transaction['time']
        HashWithUnderscoreAccess.new transaction
      end
    end
  end
end
