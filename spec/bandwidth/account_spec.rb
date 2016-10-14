describe Bandwidth::Account do
  client = nil
  before :each do
    Helper.setup_environment()
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
    Helper.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return Account info' do
      client.stubs.get('/v1/users/userId/account') {|env| [200, {}, '{"accountType":"prepay","balance": 100}']}
      expect(Account.get(client)).to eql({:account_type => 'prepay', :balance => 100})
    end

    it 'should return Account info (with default client)' do
      Helper.stubs.get('/v1/users/userId/account') {|env| [200, {}, '{"accountType":"prepay","balance": 200}']}
      expect(Account.get()).to eql({:account_type => 'prepay', :balance => 200})
    end
  end

  describe '#get_transactions' do
    it 'should return transaction data' do
      client.stubs.get('/v1/users/userId/account/transactions') {|env| [200, {}, '[{"id":1,"amount":30,"type":"charge"},{"id":2,"amount":20,"type":"payment"}]']}
      client.stubs.get('/v1/users/userId/account/transactions?test=true') {|env| [200, {}, '[{"id":10,"amount":30,"type":"charge"},{"id":20,"amount":20,"type":"payment"}]']}
      expect(Account.get_transactions(client).to_a).to eql([{:id=>1, :amount=>30, :type=>'charge'}, {:id=>2, :amount=>20, :type=>'payment'}])
      expect(Account.get_transactions(client, {:test=>true}).to_a).to eql([{:id=>10, :amount=>30, :type=>'charge'}, {:id=>20, :amount=>20, :type=>'payment'}])
    end

    it 'should return transaction data (with default client)' do
      Helper.stubs.get('/v1/users/userId/account/transactions') {|env| [200, {}, '[{"id":1,"amount":30,"type":"charge"},{"id":2,"amount":20,"type":"payment"}]']}
      Helper.stubs.get('/v1/users/userId/account/transactions?test=true') {|env| [200, {}, '[{"id":10,"amount":30,"type":"charge"},{"id":20,"amount":20,"type":"payment"}]']}
      expect(Account.get_transactions().to_a).to eql([{:id=>1, :amount=>30, :type=>'charge'}, {:id=>2, :amount=>20, :type=>'payment'}])
      expect(Account.get_transactions({:test=>true}).to_a).to eql([{:id=>10, :amount=>30, :type=>'charge'}, {:id=>20, :amount=>20, :type=>'payment'}])
    end
  end
end
