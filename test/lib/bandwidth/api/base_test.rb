require_relative '../../../test_helper'
require 'base64'

class StubbedHttpWithUser < Bandwidth::StubbedConnection
  def http
    @http ||= StubbedHttp.new @user_id, @token, @secret
  end

  alias :short_http :http

  delegate :stub, to: :http

  class StubbedHttp < Bandwidth::StubbedConnection::StubbedHttp
    def url path
      ['users', @user_id, path].join '/'
    end
  end
end

describe Bandwidth::Connection do
  before do
    @user_id = "u-ku5k3kzhbf4nligdgweuqie"
    @token = "t-apseoipfjscawnjpraalksd"
    @secret = "6db9531b2794663d75454fb42476ddcb0215f28c"

    @bandwidth = StubbedHttpWithUser.new @user_id, @token, @secret
  end

  it "passes correct user_id to API" do
    @bandwidth.stub.get("/users/#{@user_id}/account") do |request|
      [200, {}, "{}"]
    end

    @bandwidth.account.balance
  end

  it "passes correct HTTP Basic credentials to API" do
    @bandwidth.stub.get("/users/#{@user_id}/account") do |request|
      auth = request[:request_headers]["Authorization"]
      basic, auth_token = auth.split
      assert_equal "Basic", basic
      assert_equal Base64.encode64("#{@token}:#{@secret}").gsub("\n", ''), auth_token

      [200, {}, "{}"]
    end

    @bandwidth.account.balance
  end
end
