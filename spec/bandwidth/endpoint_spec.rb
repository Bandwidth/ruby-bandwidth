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
end
