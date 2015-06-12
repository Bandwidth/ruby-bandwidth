describe Bandwidth::EndPoint do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#delete' do
    it 'should remove a endpoint' do
      client.stubs.delete('/v1/users/userId/domains/1/endpoints/10') {|env| [200, {}, '']}
      item = EndPoint.new({:id=>'10'}, client)
      item.domain_id = '1'
      item.delete()
    end
  end

  describe '#create_auth_token' do
    it 'should create auth token' do
      client.stubs.post('/v1/users/userId/domains/1/endpoints/10/tokens') {|env| [201, {}, '{"expires":100, "token":"123"}']}
      item = EndPoint.new({:id=>'10'}, client)
      item.domain_id = '1'
      t = item.create_auth_token()
      expect(t[:expires]).to eql(100)
      expect(t[:token]).to eql('123')
    end
  end

  describe '#delete_auth_token' do
    it 'should delete auth token' do
      client.stubs.delete('/v1/users/userId/domains/1/endpoints/10/tokens/123') {|env| [200, {}, '']}
      item = EndPoint.new({:id=>'10'}, client)
      item.domain_id = '1'
      item.delete_auth_token('123')
    end
  end
end
