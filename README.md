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

See {Bandwidth::API::AvailableNumbers}, {Bandwidth::Types::PhoneNumber} and {Bandwidth::Types::LocalPhoneNumber}

### Local

Searches for available local numbers by location or pattern criteria.

    bandwidth.available_numbers # => [#<LocalPhoneNumber:+19195551212>, #<LocalPhoneNumber:+13125556666>, ...]

#### Filter by state, ZIP code or area code

You can filter by one of those criterias:

    bandwidth.available_numbers zip: '12345'

    bandwidth.available_numbers state: 'CA'

    bandwidth.available_numbers area_code: '919'

#### Filter by city

You can additionally specify a city:

    bandwidth.available_numbers state: 'NC', city: 'Cary'

#### Filter phone number by pattern

    bandwidth.available_numbers pattern: "*2?9*" # => [#<LocalPhoneNumber:+19192972393>, ...]

### Toll free

Searches for available Toll Free numbers.

    bandwidth.available_toll_free_numbers # => [#<PhoneNumber:+19195551212>, #<PhoneNumber:+13125556666>, ...]

#### Filter phone number by pattern

    bandwidth.available_toll_free_numbers pattern: "*2?9*" # => [#<PhoneNumber:+18557626967>, #<PhoneNumber:+18557712996>]

## Phone numbers

Lets you get phone numbers and manage numbers you already have

See {Bandwidth::API::PhoneNumbers} and {Bandwidth::Types::AllocatedPhoneNumber}

### List allocated numbers

Get a list of allocated numbers

    numbers = bandwidth.phone_numbers # => [#<AllocatedPhoneNumber:+19195551212>, #<AllocatedPhoneNumber:+13125556666>, ...]

    number = numbers.first

    # Phone number identifier
    number.id # => "n-6nuymbplrb3zd5yazve2ley"

    # Phone number in E.164 format
    number.number # => "+19195551212"

    # Phone number in human readable format
    number.national_number # => "(919) 555-1212"

    # Custom name
    number.name # => "home phone"

    # State
    number.state # => "NC"

### Allocate a number

    number_id = bandwidth.allocate_number "+19195551212"

### Check allocated phone number details

    bandwidth.phone_number_details # => #<AllocatedPhoneNumber:+19195551212>

### Remove a number from account

    bandwidth.remove_number number_id

## Calls

Lets you make phone calls and view information about previous inbound and outbound calls

See {Bandwidth::API::Calls}, {Bandwidth::Types::Call}, {Bandwidth::Types::DTMF}, {Bandwidth::Types::Record}, {Bandwidth::Audio::Sentence} and {Bandwidth::Audio::File}

### List previous calls that were made or received

Gets a list of active and historic calls you made or received

    calls = bandwidth.calls # => [#<Call:0x9906e34>, ...]
    call = calls.first

    # Call unique ID
    call.id # => "c-clgsmnrn4ruwdx36rxf7zoi"

    # Call direction (in: incoming Call, out: outgoing Call)
    call.direction # => "out"

    # Caller ID
    call.from # => "+19195551212"

    # Called ID
    call.to # => "+13125556666"

    # Call state
    call.state # => "completed"

    # Date when the call was created
    call.startTime # => 2013-02-08 13:15:47 UTC

    # Date when the call was answered
    call.activeTime # => 2013-02-08 13:15:52 UTC

    # Date when the call ended
    call.endTime # => 2013-02-08 13:15:55 UTC

    # Chargable call duration (seconds between activeTime and endTime)
    call.chargeableDuration # => 60

#### Filtering calls

You can filter by any combination of caller, callee, bridge id and conference id:

    bandwidth.calls from: "+19195551212"

    bandwidth.calls from: "+19195551212", to: "+13125556666"

    bandwidth.calls bridge_id: "brg-72x6e5d6gbthaw52vcsouyq"

    bandwidth.calls conference_id: "conf-7qrj2t3lfixl4cgjcdonkna"

### Make a phone call

    call_id = bandwidth.dial "+19195551212", "+13125556666"

#### Recording call

This will make a call and start recording immediately:

    call_id = bandwidth.dial "+19195551212", "+13125556666", recording_enabled: true

#### Bridging a call

This will create a call in a bridge:

    bridge_id = "brg-72x6e5d6gbthaw52vcsouyq"
    call_id = bandwidth.dial "+19195551212", "+13125556666", bridge_id: bridge_id

### Get information about a call that was made or received

Gets information about an active or completed call

    call = bandwidth.call_info "c-xytsl6nfcayzsxdbqq7q36i"

### Make changes to an active phone call

Changes properties of an active phone call

#### Hang up

    bandwidth.hangup "c-xytsl6nfcayzsxdbqq7q36i"

#### Transfer

    bandwidth.transfer "c-xytsl6nfcayzsxdbqq7q36i", "+19195551212"

It's also possible to set caller id:

    bandwidth.transfer "c-xytsl6nfcayzsxdbqq7q36i", "+19195551212", transfer_caller_id: "+19195553131"

and/or play audio file or speak some text:

    audio = Bandwidth::Audio::Sentence.new "Call has been transferred"
    bandwidth.transfer "c-xytsl6nfcayzsxdbqq7q36i", "+19195551212", audio: audio

#### Set recording state

To start recording:

    bandwidth.recording_state "c-xytsl6nfcayzsxdbqq7q36i", true

### Play an audio or speak a sentence in a call

Plays an audio file or speak a sentence in a phone call

    sentence = Bandwidth::Audio::Sentence.new "Hello, thank you for calling."
    audio_file = Bandwidth::Audio::File.new "http://example.com/audio.mp3"

    bandwidth.play call_id, sentence
    bandwidth.play call_id, audio_file

#### Sentence options

You can set a locale and gender (default is female):

    audio = Bandwidth::Audio::Sentence.new "Guten Tag",
      locale: Bandwidth::Audio::Sentence::LOCALE_DE,
      gender: Bandwidth::Audio::Sentence::MALE

    bandwidth.play audio

#### General options

You can play audio in a loop:

    audio = Bandwidth::Audio::File.new "http://example.com/audio.mp3", loop_enabled: true
    bandwidth.play audio

### Send DTMF

Send DTMF to the call

    bandwidth.dtmf call_id, "1234"

### Wait until the specified number of DTMF digits are pressed

    dtmf = bandwidth.gather call_id
    dtmf.digits # => "*123#"

#### Options

You can specify options.

The maximum number of digits to collect, not including terminating digits (maximum 30)

    dtmf = bandwidth.gather call_id, max_digits: 3

Stop gathering if a DTMF digit is not detected in this many seconds (default 5.0; maximum 30.0)

    dtmf = bandwidth.gather call_id, inter_digit_timeout: 10

A string of DTMF digits that end the gather operation immediately if any one of them is detected (default "#"; an empty string means collect all DTMF until maxDigits or the timeout).
The gather ends if either 0, #, or * is detected:

    dtmf = bandwidth.gather call_id, terminating_digits: "0#*"

A string you choose that will be included with the response and events for this gather operation

    dtmf = bandwidth.gather call_id, tag: 'abc123'

Plays or speaks to a call when gathering DTMF.
Note a specical bargeable parameter to interrupt prompt (audio or sentence) at first digit gathered (default is true).

    audio = Bandwidth::Audio::File.new "http://example.com/audio.mp3", bargeable: false
    dtmf = bandwidth.gather call_id, audio: audio

### Retrieve all recordings related to the call

    records = bandwidth.records call_id
    record = records.first

    record.id # => "rec-togfrwqp2bxxezstzbzadra"
    record.media # => "https://.../v1/users/.../media/c-j4gferrrn72ivf3ov56ccay-1.wav"
    record.start_time # => 2013-02-08 12:05:17 UTC
    record.end_time # => 2013-02-08 13:15:55 UTC
    record.state # => "complete"

# Useful links

Original api docs: https://catapult.inetwork.com/docs/
