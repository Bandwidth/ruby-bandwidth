module Bandwidth
  module API
    module Account

      # Get account information
      #
      # @return [Types::Account]
      def account
        Types::Account.new get 'account'
      end

      # Get the transactions from the user's Account
      #
      # @param [Hash] options The options to create a request with
      # @option options [String] :type Filter by specific payment type (see {TransactionTypes} for allowed values)
      # @option options [Time] :from_date From a specific point of time
      # @option options [Time] :to_date Up to specific point of time
      # @option options [Integer] :max_items Limit quantity of returned items
      #
      # @return [Array<Types::Transaction>]
      #
      # @example Getting a list of transactions
      #   transactions = bandwidth.transactions # => [#<Transaction:0xb642ffc>, #<Transaction:0xb642fe8>]
      #
      #   example_transaction.time # => 2013-02-21 13:39:09 UTC
      #   example_transaction.amount # => 0.0075
      #   example_transaction.type # => "charge"
      #   example_transaction.units # => "1"
      #   example_transaction.product_type # => "sms-out"
      #
      # @example Filter by time period
      #   from = "2013-02-21T13:38:00Z"
      #   to = "2013-02-21T13:40:00Z"
      #
      #   transactions = bandwidth.transactions from_date: Time.parse(from), to_date: Time.parse(to)
      #
      # @example Filter by payment type
      #   transactions = bandwidth.transactions type: Bandwidth::API::Account::TransactionTypes::AUTO_RECHARGE
      #
      # @example Limit quantity
      #   transactions = bandwidth.transactions max_items: 5 # Will return maximum 5 transactions
      #
      def transactions options = {}
        options[:from_date] = options[:from_date].iso8601 if options[:from_date]
        options[:to_date] = options[:to_date].iso8601 if options[:to_date]

        transactions = get 'account/transactions', options

        transactions.map do |transaction|
          Types::Transaction.new transaction
        end
      end

      # Transaction Types
      module TransactionTypes
        # @return [String] A charge for the use of a service or resource (for example, phone calls, SMS messages, phone numbers)
        CHARGE = 'charge'.freeze

        # @return [String] A payment you made to increase your account balance
        PAYMENT= 'payment'.freeze

        # @return [String] An increase to your account balance that you did not pay for (for example, an initial account credit or promotion)
        CREDIT= 'credit'.freeze

        # @return [String] An automated payment made to keep your account balance above the minimum balance you configured
        AUTO_RECHARGE = 'auto-recharge'.freeze
      end

      # Product Types
      module ProductTypes
        # @return [String] An SMS message that came in to one of your numbers
        SMS_IN = 'sms-in'.freeze

        # @return [String] An SMS message that was sent from one of your numbers
        SMS_OUT = 'sms-out'.freeze

        # @return [String] A phone call that came in to one of your numbers
        CALL_IN = 'call-in'.freeze

        # @return [String] A phone call that was made from one of your numbers
        CALL_OUT = 'call-out'.freeze

        # @return [String] The monthly charge for a local phone number you have
        LOCAL_NUMBER_PER_MONTH = 'local-number-per-month'.freeze

        # @return [String] The monthly charge for a toll-free phone number you have
        TOLL_FREE_NUMBER_PER_MONTH= 'toll-free-number-per-month'.freeze
      end
    end
  end
end
