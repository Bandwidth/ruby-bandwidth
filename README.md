# ruby-bandwidth

Gem for integrating to Bandwidth's Telephony API


## Installation

Via rubygems:

    gem install bandwidth

or add to your Gemfile:

    gem 'bandwidth'

## Usage

### Basic

    require 'bandwidth' # Optional, only unless you use Bundler to manage dependencies

    USER_ID = "u-ku5k3kzhbf4nligdgweuqie" # Your user id
    TOKEN  = "t-apseoipfjscawnjpraalksd" # Your account token
    SECRET = "6db9531b2794663d75454fb42476ddcb0215f28c" # Your secret
    bandwidth = Bandwidth.new USERID, TOKEN, SECRET

### Account

    bandwidth.account.balance # => 538.3725
    bandwidth.account.account_type # => "pre-pay"

### Transactions

    transactions = bandwidth.transactions # => [#<Transaction:0xb642ffc>, #<Transaction:0xb642fe8>]
    example_transaction = transactions.first

    example_transaction.id # => "pptx-wqfnffduxiki4fd5ubhv77a"
    example_transaction.time # => 2013-02-21 13:39:09 UTC
    example_transaction.amount # => 0.0075
    example_transaction.type # => "charge"
    example_transaction.units # => "1"
    example_transaction.product_type # => "sms-out"
    example_transaction.number # => "+12345678910"

#### Filter by time period

    from = "2013-02-21T13:38:00Z"
    to = "2013-02-21T13:40:00Z"

    transactions = bandwidth.transactions from_date: Time.parse(from), to_date: Time.parse(to)

#### Filter by payment type

    transactions = bandwidth.transactions type: Bandwidth::API::Account::TransactionTypes::AUTO_RECHARGE

Available payment types:

    CHARGE, PAYMENT, CREDIT, AUTO_RECHARGE

#### Limit quantity

    transactions = bandwidth.transactions max_items: 5 # Will return maximum 5 transactions


Useful links
============

Original api docs: https://catapult.inetwork.com/docs/
