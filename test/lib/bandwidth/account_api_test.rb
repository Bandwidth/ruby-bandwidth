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

    assert_equal @bandwidth.account.balance, 538.3725
    assert_equal @bandwidth.account.account_type, "pre-pay"
  end

  it "returns a list of transactions" do
    @bandwidth.stub.get('/account/transactions') {[200, {}, <<-JSON
      [
        {
          "id": "pptx-wqfnffduxiki4fd5ubhv77a",
          "time": "2013-02-21T13:39:09.122Z",
          "amount": "0.00750",
          "type": "charge",
          "units": "1",
          "productType": "sms-out",
          "number": "+12345678910"
        },
        {
          "id": "pptx-mvhqse4weiuzplt6bvqjuyi",
          "time": "2013-02-21T13:37:42.079Z",
          "amount": "0.00750",
          "type": "charge",
          "units": "1",
          "productType": "sms-out",
          "number": "+12345678910"
        }
      ]
      JSON
    ]}

    transactions = @bandwidth.transactions
    assert_equal transactions.size, 2

    transaction = transactions.first
    assert_equal transaction.id, "pptx-wqfnffduxiki4fd5ubhv77a"
    assert_equal transaction.time, "2013-02-21T13:39:09.122Z"
    assert_equal transaction.amount, 0.00750
    assert_equal transaction.type, "charge"
    assert_equal transaction.units, "1"
    assert_equal transaction.product_type, "sms-out"
    assert_equal transaction.number, "+12345678910"
  end
end
