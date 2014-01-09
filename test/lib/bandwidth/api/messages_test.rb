require_relative '../../../test_helper'

describe Bandwidth::API::Messages do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "sends a message and returns message id" do
    message_id = "m-6usiz7e7tsjjafn5htk5huy"

    @bandwidth.stub.post('/messages') {[201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/messages/#{message_id}"}, ""]}

    assert_equal message_id, @bandwidth.send_message("+19195555555", "+13125555555", "Test message")
  end

  it "sets message parameters" do
    message_id = "m-6usiz7e7tsjjafn5htk5huy"

    from = "+19195555555"
    to = "+13125555555"
    text = "Test message"

    @bandwidth.stub.post('/messages') do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal from, parsed_body['from']
      assert_equal to, parsed_body['to']
      assert_equal text, parsed_body['text']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/messages/#{message_id}"}, ""]
    end

    @bandwidth.send_message from, to, text
  end

  it "handles restricted-number return code on send" do
    @bandwidth.stub.post('/messages') {[403, {}, <<-JSON
      {
        "category": "forbidden",
        "code": "restricted-number",
        "message": "The number +19195555555 is restricted and cannot be used to send message.",
        "details": [
          {"name": "requestMethod", "value": "POST"},
          {"name": "requestPath", "value": "users/user_id/messages"}
        ]
      }
      JSON
    ]}

    assert_raises Bandwidth::Errors::RestrictedNumber, "The number +19195555555 is restricted and cannot be used to send message." do
      @bandwidth.send_message("+19195555555", "+13125555555", "Test message")
    end
  end

  it "gets a message by id" do
    message_id = "m-6usiz7e7tsjjafn5htk5huy"

    @bandwidth.stub.get("/messages/#{message_id}") {[200, {}, <<-JSON
      {
        "id": "m-6usiz7e7tsjjafn5htk5huy",
        "messageId": "m-6usiz7e7tsjjafn5htk5huy",
        "from": "+19195551212",
        "to": "+13125556666",
        "text": "Good morning, this is a test message",
        "time": "2012-10-05T20:37:38.048Z",
        "direction": "out",
        "state": "sent"
      }
      JSON
    ]}

    message = @bandwidth.message message_id

    assert_equal message_id, message.id
    assert_equal "out", message.direction
    assert_equal "+19195551212", message.from
    assert_equal "+13125556666", message.to
    assert_equal "sent", message.state
    assert_equal Time.parse("2012-10-05T20:37:38.048Z"), message.time
    assert_equal "Good morning, this is a test message", message.text
  end

  it "gets a list of messages" do
    @bandwidth.stub.get("/messages") do |request|
      page = request[:params]['page'].to_i
      if page > 0
        [200, {}, "[]"]
      else
        [200, {}, <<-JSON
          [
            {
              "id": "m-6usiz7e7tsjjafn5htk5huy",
              "messageId": "m-6usiz7e7tsjjafn5htk5huy",
              "from": "+19195551212",
              "to": "+13125556666",
              "text": "Good morning, this is a test message",
              "time": "2012-10-05T20:37:38.048Z",
              "direction": "out",
              "state": "sent"
            },
            {
              "id": "m-ysgivd4qyxylwgs6mvyg6oy",
              "messageId": "m-ysgivd4qyxylwgs6mvyg6oy",
              "from": "+13125556666",
              "to": "+19195551212",
              "text": "I received your test message",
              "time": "2012-10-05T20:38:11.023Z",
              "direction": "in",
              "state": "sent"
            }
          ]
          JSON
        ]
      end
    end

    messages = @bandwidth.messages
    assert_equal 2, messages.size
  end

  it "paginates results" do
    first_id = "m-6usiz7e7tsjjafn5htk5huy"
    last_id = "m-ysgivd4qyxylwgs6mvyg6oy"

    @bandwidth.stub.get("/messages") do |request|
      assert_equal 25, request[:params]['size'].to_i

      id = request[:params]['page'].to_i == 0 ? first_id : last_id

      if request[:params]['page'].to_i > 1
        [200, {}, "[]"]
      else
        [200, {}, (
          "[" + (0..24).map {
          <<-JSON
            {
              "id": "#{id}",
              "messageId": "#{id}",
              "from": "+13125556666",
              "to": "+19195551212",
              "text": "I received your test message",
              "time": "2012-10-05T20:38:11.023Z",
              "direction": "in",
              "state": "sent"
            }
          JSON
        }.join(',') + "]")
        ]
      end
    end

    messages = @bandwidth.messages
    assert_equal "m-6usiz7e7tsjjafn5htk5huy", messages.first.id
    assert_equal "m-ysgivd4qyxylwgs6mvyg6oy", messages[25].id
    assert_equal nil, messages[50]
  end

  it "filters list of messages by sender" do
    sender = "+19195551212"

    @bandwidth.stub.get("/messages") do |request|
      assert_equal sender, request[:params]['from']
      [200, {}, "{}"]
    end

    @bandwidth.messages from: sender
  end

  it "filters list of messages by recipient" do
    recipient = "+13125556666"

    @bandwidth.stub.get("/messages") do |request|
      assert_equal recipient, request[:params]['to']
      [200, {}, "{}"]
    end

    @bandwidth.messages to: recipient
  end
end
