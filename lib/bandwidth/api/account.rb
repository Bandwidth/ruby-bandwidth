require 'time'

module Bandwidth
  module API
    module Account

      # Get account information
      #
      # @return [Account]
      def account
        Types::Account.new get 'account'
      end

      CHARGE, PAYMENT, CREDIT, AUTO_RECHARGE = %w{charge payment credit auto-recharge}.map &:freeze

      def transactions params = {}
        params[:from_date] = params[:from_date].iso8601 if params[:from_date]
        params[:to_date] = params[:to_date].iso8601 if params[:to_date]

        transactions = get 'account/transactions', params

        transactions.map do |transaction|
          Types::Transaction.new transaction
        end
      end
    end
  end
end
