# ruby-bandwidth

Gem for integrating to Bandwidth's Telephony API


# Installation

Via rubygems:

    gem install bandwidth

or add to your Gemfile:

    gem 'bandwidth'

# Usage

## Basic

    require 'bandwidth' # Optional, only unless you use Bundler to manage dependencies

    USERID = "u-ku5k3kzhbf4nligdgweuqie" # Your user id
    TOKEN  = "t-apseoipfjscawnjpraalksd" # Your account token
    SECRET = "6db9531b2794663d75454fb42476ddcb0215f28c" # Your secret
    bandwidth = Bandwidth.new USERID, TOKEN, SECRET

## Account

### General

    bandwidth.account.balance # => 538.3725
    bandwidth.account.account_type # => "pre-pay"

### Transactions

    transactions = bandwidth.transactions # => [#<transaction:0xb642ffc>, #<transaction:0xb642fe8>]
    example_transaction = transactions.first

TODO: use .inspect?
    example_transaction.id # => "pptx-wqfnffduxiki4fd5ubhv77a"
    example_transaction.time # => 2013-02-21 13:39:09 UTC
    example_transaction.amount # => 0.0075
    example_transaction.type # => "charge"
    example_transaction.units # => "1"
    example_transaction.product_type # => "sms-out"
    example_transaction.number # => "+12345678910"

#### Limit by time period

Useful links
============

Original api docs: https://catapult.inetwork.com/docs/
