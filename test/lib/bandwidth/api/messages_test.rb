require_relative '../../../test_helper'

describe Bandwidth::API::Account do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "sends a message and returns message id" do
    message_id = "m-6usiz7e7tsjjafn5htk5huy"

    @bandwidth.stub.post('/messages') {[201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/messages/#{message_id}"}, ""]}

    assert_equal message_id, @bandwidth.send_message("+19195555555", "+13125555555", "Test message")
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
end
