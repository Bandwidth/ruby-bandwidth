require_relative '../../test_helper'

describe Bandwidth::AccountAPI do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "returns account balance and type" do
    @bandwidth.stub.get('/account') {[200, {}, <<-JSON
      {
        "balance": "538.37250",
        "accountType": "pre-pay"
      }
      JSON
    ]}

    @bandwidth.account.balance == 538.3725
    @bandwidth.account.account_type == "pre-pay"
  end
end
