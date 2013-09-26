require_relative '../../../test_helper'

describe Bandwidth::API::Account do
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

    assert_equal 538.3725, @bandwidth.account.balance
    assert_equal "pre-pay", @bandwidth.account.account_type
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
    assert_equal 2, transactions.size

    transaction = transactions.first
    assert_equal "pptx-wqfnffduxiki4fd5ubhv77a", transaction.id
    assert_equal Time.parse("2013-02-21T13:39:09.122Z"), transaction.time
    assert_equal 0.00750, transaction.amount
    assert_equal "charge", transaction.type
    assert_equal "1", transaction.units
    assert_equal "sms-out", transaction.product_type
    assert_equal "+12345678910", transaction.number
  end

  it "filters by date" do
    from = "2013-02-21T13:38:00Z"
    to = "2013-02-21T13:40:00Z"

    @bandwidth.stub.get("/account/transactions") do |request|
      assert_equal from, request[:params]['fromDate']
      assert_equal to, request[:params]['toDate']
      [200, {}, "{}"]
    end

    transactions = @bandwidth.transactions from_date: Time.parse(from), to_date: Time.parse(to)
  end

  it "filters by payment type" do
    @bandwidth.stub.get("/account/transactions") do |request|
      assert_equal "auto-recharge", request[:params]['type']
      [200, {}, "{}"]
    end

    transactions = @bandwidth.transactions type: Bandwidth::API::Account::TransactionTypes::AUTO_RECHARGE
  end

  it "limits the results" do
    @bandwidth.stub.get("/account/transactions") do |request|
      assert_equal "1", request[:params]['maxItems']
      [200, {}, "{}"]
    end

    transactions = @bandwidth.transactions max_items: 1
  end
end
