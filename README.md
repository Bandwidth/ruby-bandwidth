# Bandwidth Ruby API

Gem for integrating to Bandwidth's Telephony API

# Installation

Via rubygems:

    gem install bandwidth

or add to your Gemfile:

    gem 'bandwidth'

# Usage

## Basic

See {Bandwidth}

Optional, only unless you use Bundler to manage dependencies:

    require "bandwidth"

Initialize API access object and connect to your account data:

    USER_ID = "u-ku5k3kzhbf4nligdgweuqie" # Your user id
    TOKEN  = "t-apseoipfjscawnjpraalksd" # Your account token
    SECRET = "6db9531b2794663d75454fb42476ddcb0215f28c" # Your secret
    bandwidth = Bandwidth.new USERID, TOKEN, SECRET

## Account

See {Bandwidth::API::Account} and {Bandwidth::Types::Account}

    bandwidth.account.balance # => 538.3725
    bandwidth.account.account_type # => "pre-pay"

## Transactions

See {Bandwidth::API::Account} and {Bandwidth::Types::Transaction}

### Get a list of transactions

    transactions = bandwidth.transactions # => [#<Transaction:0xb642ffc>, #<Transaction:0xb642fe8>]
    example_transaction = transactions.first

    # A unique identifier for the transaction
    example_transaction.id # => "pptx-wqfnffduxiki4fd5ubhv77a"

    # The time the transaction was processed
    example_transaction.time # => 2013-02-21 13:39:09 UTC

    # The transaction amount in dollars, as a string; the currency symbol is not included
    example_transaction.amount # => 0.0075

    # The type of transaction
    example_transaction.type # => "charge"

    # The number of product units the transaction charged or credited
    example_transaction.units # => "1"

    # The product the transaction was related to (not all transactions are related to a product)
    example_transaction.product_type # => "sms-out"

    # The phone number the transaction was related to (not all transactions are related to a phone number)
    example_transaction.number # => "+12345678910"

    # Used for pagination to indicate the page requested for querying a list of transactions. If no value is specified the default is 0.
    example_transaction.page

    # Used for pagination to indicate the size of each page requested for querying a list of transactions. If no value is specified the default value is 25. (Maximum value 1000)
    example_transaction.size

### Filter by time period

    from = "2013-02-21T13:38:00Z"
    to = "2013-02-21T13:40:00Z"

    transactions = bandwidth.transactions from_date: Time.parse(from), to_date: Time.parse(to)

### Filter by payment type

    transactions = bandwidth.transactions type: Bandwidth::API::Account::TransactionTypes::AUTO_RECHARGE

Available payment types:

    CHARGE, PAYMENT, CREDIT, AUTO_RECHARGE

### Limit quantity

    transactions = bandwidth.transactions max_items: 5 # Will return maximum 5 transactions

## Messages

See {Bandwidth::API::Messages} and {Bandwidth::Types::Message}

### Send text messages

    from = "+19195551212"
    to = "+13125556666"
    text = "Good morning, this is a test message"

    message_id = bandwidth.send_message from, to, text

### Get message

    message = bandwidth.message message_id

    # A unique ID of the message
    message.id # => "m-6usiz7e7tsjjafn5htk5huy"

    # Message direction. One of:
    # in: A message that came from the telephone network to one of your numbers (an "inbound" message)
    # out: A message that was sent from one of your numbers to the telephone network (an "outbound" message)
    message.direction # => "out"

    # The message sender's telephone number
    message.from # => "+19195551212"

    # The message sender's telephone number
    message.to # => "+13125556666"

    # One of the message states
    message.state # => "sent"

    # The time the message resource was created (follows the ISO 8601 format)
    message.time # => 2012-10-05 20:38:11 UTC

    # The message contents
    message.text # => "Good morning, this is a test message"

    # Used for pagination to indicate the page requested for querying a list of messages. If no value is specified the default is 0.
    message.page

    # Used for pagination to indicate the size of each page requested for querying a list of messages. If no value is specified the default value is 25. (Maximum value 1000)   messa
    message.size

### Get a list of messages

    messages = bandwidth.messages # => [#<Message:0xb642ffc>, #<Message:0xb642fe8>]

### Get a list of messages filtering by sender or/and recipient

    messages = bandwidth.messages from: "+19195551212", to:"+13125556666" # => [#<Message:0xa8526e0>, #<Message:0xa85ee7c>]

## Available phone numbers

Lets you search for numbers that are available for use with your application.

### Local

Searches for available local numbers by location or pattern criteria.

    bandwidth.available_numbers # => [#<PhoneNumber:+19195551212>, #<PhoneNumber:+13125556666>, ...]

### Toll freme

Searches for available Toll Free numbers.

    bandwidth.available_toll_free_numbers # => [#<PhoneNumber:+19195551212>, #<PhoneNumber:+13125556666>, ...]

# Useful links

Original api docs: https://catapult.inetwork.com/docs/
