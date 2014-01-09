# American idol voting maching machine
#
# Scenario:
#   Allocate a phone number
#   Periodically poll for new SMS to that number
#   Check and reply to new SMS

require "bandwidth"

class AmericanIdolVoting
  attr_reader :phone_number

  def initialize user_id, token, secret, voting_options
    @bandwidth = Bandwidth.new user_id, token, secret
    @processed_messages = []
    @votes = {}
    @voting_options = voting_options
    allocate_phone_number
  end

  def start
    loop do
      poll
    end
  end

protected
  attr_reader :bandwidth, :processed_messages, :votes, :voting_options

  def allocate_phone_number
    local_phone_number = bandwidth.available_numbers.first
    phone_number = bandwidth.allocate_phone_number local_phone_number.number
    @phone_number = phone_number.number
  end

  def poll
    messages = bandwidth.messages to: phone_number
    messages.each do |message|
      next if processed_messages.include? message.id

      process_vote message
    end
  end

  def process_vote message
    vote = message.text.strip
    if voting_options.keys.include? vote
      # Save or update vote
      store_vote vote, message.from
    else
      # Notify sender of incorrect vote
      text = "'#{vote} is incorrect. Please use one of: #{voting_options.keys.join(' ')}"
      bandwidth.send_message phone_number, message.from, text
    end
  end

  def store_vote from, vote
    previous_vote = votes[message.from] # Check if sender has voted already

    text = if previous_vote
             "Your vote has been updated to #{voting_options[vote]}"
           else
             "Your vote for #{voting_options[vote]} has been accepted"
           end

    bandwidth.send_message phone_number, message.from, text

    processed_messages << message.id
    votes[message.from] = vote
  end
end

user_id = "u-ku5k3kzhbf4nligdgweuqie" # your user id
token  = "t-apseoipfjscawnjpraalksd" # your account token
secret = "6db9531b2794663d75454fb42476ddcb0215f28c" # your secret

# Initialize voting machine with your Bandwidth credentials and voting options
voting = AmericanIdolVoting.new user_id, token, secret, {
 "111" => "Just Inbieber",
 "222" => "Two Direction"
}

# Publish this number to your voters
voting.phone_number # => +19192972393

# Start voting machine
voting.start
