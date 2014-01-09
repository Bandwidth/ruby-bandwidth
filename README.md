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
    bandwidth = Bandwidth.new USER_ID, TOKEN, SECRET

## Examples

See examples folder for real world examples

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

### Filter by time period

    from = "2013-02-21T13:38:00Z"
    to = "2013-02-21T13:40:00Z"

    transactions = bandwidth.transactions from_date: Time.parse(from), to_date: Time.parse(to)

### Filter by payment type

    transactions = bandwidth.transactions type: Bandwidth::API::Account::TransactionTypes::AUTO_RECHARGE

Available payment types:

    CHARGE, PAYMENT, CREDIT, AUTO_RECHARGE

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
    call.start_time # => 2013-02-08 13:15:47 UTC

    # Date when the call was answered
    call.active_time # => 2013-02-08 13:15:52 UTC

    # Date when the call ended
    call.end_time # => 2013-02-08 13:15:55 UTC

    # Chargeable call duration (seconds between activeTime and endTime)
    call.chargeable_duration # => 60

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

A string of DTMF digits that end the gather operation immediately if any one of them is detected (default "#"; an empty string means collect all DTMF until max\_digits or the timeout).
The gather ends if either 0, #, or * is detected:

    dtmf = bandwidth.gather call_id, terminating_digits: "0#*"

A string you choose that will be included with the response and events for this gather operation

    dtmf = bandwidth.gather call_id, tag: 'abc123'

Plays or speaks to a call when gathering DTMF.
Note a specical bargeable parameter to interrupt prompt (audio or sentence) at first digit gathered (default is true).

    audio = Bandwidth::Audio::File.new "http://example.com/audio.mp3", bargeable: false
    dtmf = bandwidth.gather call_id, audio: audio

### Retrieve all recordings related to the call

    records = bandwidth.call_records call_id
    record = records.first

    record.id # => "rec-togfrwqp2bxxezstzbzadra"
    record.media # => "c-j4gferrrn72ivf3ov56ccay-1.wav"
    record.start_time # => 2013-02-08 12:05:17 UTC
    record.end_time # => 2013-02-08 13:15:55 UTC
    record.state # => "complete"

## Media

Media API lets you upload your media files to Bandwidth servers so they can be used in scripts without requiring a separate hosting provider. You can upload files up to 50 MB and file storage is free for an unlimited number of files.
These files are not available for public download. Media files include all call recordings.

See {Bandwidth::API::Media} and {Bandwidth::Types::Medium}

### Get a list of your media files

    media = bandwidth.media # => [#<Medium:0xa3e7948>, ...]

    medium = media.first
    medium.content_length # => 2703360
    medium.media_name # => "mysong.mp3"

### Uploads a media file to the name you choose

    bandwidth.upload "greeting.mp3", File.new("greeting.mp3")

    bandwidth.upload "greeting.mp3", StringIO.new(some_binary_data_here)

### Download media file

    data = bandwidth.download "c-bonay3r4mtwbplurq4nkt7q-1.wav"

### Permanently deletes a media file you uploaded

    bandwidth.delete_media "greeting.mp3"

## Recordings

Retrieve call recordings, filtering by Id, user and/or calls.
The recording information retrieved by GET method contains only textual data related to call recording as described on Properties section. To properly work with recorded media content such as download and removal of media file, please access Media documentation.

See {Bandwidth::API::Records} and {Bandwidth::Types::RecordWithCall}

### List records

List a user's call records

    records = bandwidth.records # => [#<Record:0xa798bf0>, ...]

    record = records.first
    record.end_time # => 2013-02-08 13:15:47 UTC
    record.id # => "rec-togfrwqp2bxxezstzbzadra"
    record.media # => "c-bonay3r4mtwbplurq4nkt7q-1.wav"
    record.call # => "call": "c-bonay3r4mtwbplurq4nkt7q"
    record.start_time # => 2013-02-08 13:16:35 UTC
    record.state # => "complete"

### Get recording information

    bandwidth.record "rec-togfrwqp2bxxezstzbzadra" # => #<Record:0xa798bf0>

## Bridges

Bridge two calls allowing two way audio between them.

See {Bandwidth::API::Bridges} and {Bandwidth::Types::Bridge}

### Get a list of previous bridges

    bridges = bandwidth.bridges # => [#<Bridge:0xa466c5c>, ...]

    bridge = bridges.first
    bridge.id # => "brg-7cp5tvhydw4a3esxwpww5qa"
    bridge.state # => "completed"
    bridge.bridge_audio # => true
    bridge.created_time => 2013-04-22 13:55:30 UTC
    bridge.activated_time => 2013-04-22 13:55:30 UTC
    bridge.completed_time => 2013-04-22 13:56:30 UTC

### Create a bridge

    bandwidth.bridge "c-mxdxhidpjr6a2bp2lxq6vaa", "c-c2rui2kbrldsfgjhlvlnjaq"

#### Disable two way audio path

Audio is bridged by default, but it's possible to override that passing an option:

    bandwidth.bridge "c-mxdxhidpjr6a2bp2lxq6vaa", "c-c2rui2kbrldsfgjhlvlnjaq", bridge_audio: false

### Get information about a specific bridge

    bandwidth.bridge_info "brg-7cp5tvhydw4a3esxwpww5qa" # => <Bridge:0xa466c5c>

### Bridging audio

    bandwidth.bridge_audio "brg-7cp5tvhydw4a3esxwpww5qa", true

### Play a media file or speak a sentence in a bridge

    sentence = Bandwidth::Audio::Sentence.new "Hello, thank you for calling."
    audio_file = Bandwidth::Audio::File.new "http://example.com/audio.mp3"

    bandwidth.bridge_play bridge_id, sentence
    bandwidth.bridge_play bridge_id, audio_file

### Destroy bridge

Removes all calls from bridge. It will also change the bridge state to 'completed' and this bridge can not be updated anymore

    bandwidth.unbridge bridge_id

### Get the calls that are on the bridge

    calls = bandwidth.bridged_calls "brg-7cp5tvhydw4a3esxwpww5qa" # => [#<BridgedCall:0x9906e34>, #<BridgedCall:0xaf0f208>]

    call = calls.first
    call.bridge_id # => "brg-7cp5tvhydw4a3esxwpww5qa"
    call.id # => "c-clgsmnrn4ruwdx36rxf7zoi"
    call.direction # => "out"
    call.from # => "+19195551212"
    call.to # => "+13125556666"
    call.state # => "active"
    call.startTime # => 2013-02-08 13:15:47 UTC
    call.activeTime # => 2013-02-08 13:15:52 UTC
    call.recording_enabled # => false

## Conferences

Allows you create conferences, add members to it, play audio, speak text, mute/unmute members, hold/unhold members and other things related to conferencing.

See {Bandwidth::API::Conferences}, {Bandwidth::Types::Conference} and {Bandwidth::Types::ConferenceMember}

### Create aa conference

Creates a conference with no members

    conference_id = bandwidth.conference "+19195551212" # => "conf-7qrj2t3lfixl4cgjcdonkna"

### Retrieve conference information

    bandwidth.conference_info "conf-7qrj2t3lfixl4cgjcdonkna"

### Terminate conference

    bandwidth.conference_terminate "conf-7qrj2t3lfixl4cgjcdonkna"

### Muting conference

    bandwidth.conference_mute "conf-7qrj2t3lfixl4cgjcdonkna", true

### Play an audio/speak a sentence in the conference

    bandwidth.conference_play "conf-7qrj2t3lfixl4cgjcdonkna", audio

### Add a member to a conference

    call_id = bandwidth.dial "+19195551212", "+13125556666"
    member_id = bandwidth.conference_add "conf-7qrj2t3lfixl4cgjcdonkna", call_id # => "member-ae4b8krsskpuvnw6nsitg78"

### List all members from a conference

    members = bandwidth.conference_members "conf-7qrj2t3lfixl4cgjcdonkna"

    member = members.first
    member.id # => "member-i3bgynrxllq3v3wiisiuz2q"
    member.added_time # => 2013-07-12 17:54:47 UTC
    member.hold # => false
    member.mute # => false
    member.state # => "active"
    member.call # => "c-lem5j6326b2nyrej7ieheki"

### Conference member operations

#### Remove from conference

    bandwidth.conference_member_remove conference_id, member_id

#### Muting

    bandwidth.conference_member_mute conference_id, member_id, true

#### Putting on hold

    bandwidth.conference_member_hold conference_id, member_id, true

#### Play an audio/speak a sentence

    sentence = Bandwidth::Audio::Sentence.new "Hello, thank you for calling."
    audio_file = Bandwidth::Audio::File.new "http://example.com/audio.mp3"

    bandwidth.conference_member_play conference_id, member_id, sentence
    bandwidth.conference_member_play conference_id, member_id, audio_file

#### Retrieve information about a particular conference member

    member = bandwidth.conference_member_info conference_id, member_id
    member.id # => "member-i3bgynrxllq3v3wiisiuz2q"
    member.added_time # => 2013-07-12 17:54:47 UTC
    member.hold # => false
    member.mute # => false
    member.state # => "active"
    member.call # => "c-lem5j6326b2nyrej7ieheki"

# Useful links

Original api docs: https://catapult.inetwork.com/docs/

# For contributors

## Prerequisites

You will need some gems to test and develop bandwidth gem. Install them:

    gem install bundler
    bundle install

## Running tests

    rake

## Building and installing gem

    gem build bandwidth.gemspec
    gem install bandwidth<VERSION>.gem

## Documentation generation

Generates documentation:

    yard doc

Check what's not covered by documentation:

    yard stats --list-undoc

Start local documentation server at http://localhost:8808/docs

    yard server

## Contribution guidelines

Create a topic branch.
Fix the issue.
Cover with tests.
Add documentation.
Send pull request with commentary.
