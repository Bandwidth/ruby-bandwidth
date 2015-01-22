
[![Build](https://travis-ci.org/bandwidthcom/ruby-bandwidth.png)](https://travis-ci.org/bandwidthcom/ruby-bandwidth)

# Bandwidth Catapult Ruby API

Gem for integrating to Bandwidth's Catapult  API

# Installation

Via rubygems:

    gem install bandwidth

or add to your Gemfile:

    gem 'bandwidth'

# Usage

```ruby

# Using client instance directly

client = Client.new(:user_id => "userId", :api_token => "token", :api_secret => "secret")
calls = Call.list(client, {:page => 1})

# Or you can use default client instance
# You should set up its global options before using of api functions

# Do that only once

  Client.global_options = {:user_id => "userId", :api_token => "token", :api_secret => "secret"}
# Now you can call any functions without first arg 'client'

  calls = Call.list(:page=>1)

```


# Useful links

[Original API  docs](https://catapult.inetwork.com/docs/)
