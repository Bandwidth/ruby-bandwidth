describe Bandwidth::Application do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return specific item' do
      client.stubs.get('/v1/users/userId/applications/1') {|env| [200, {}, '{"id":"1","name":"app1","incomingCallUrl":"http://host1"}']}
      expect(Application.get(client, '1').to_data()).to eql({:id=>'1', :name=>'app1', :incoming_call_url=>'http://host1'})
    end
  end

  describe '#list' do
    it 'should return items' do
      client.stubs.get('/v1/users/userId/applications') {|env| [200, {}, '[{"id":"1","name":"app1","incomingCallUrl":"http://host1"}]']}
      expect(Application.list(client).map {|i| i.to_data()}).to eql([{:id=>'1', :name=>'app1', :incoming_call_url=>'http://host1'}])
    end
  end

  describe '#update' do
    it 'should change item' do
      client.stubs.post('/v1/users/userId/applications/1', '{"name":"new name"}') {|env| [200, {}, '']}
      item = Application.new({:id=>'1'}, client)
      item.update({:name=>'new name'})
    end
  end

  describe '#delete' do
    it 'should remove item' do
      client.stubs.delete('/v1/users/userId/applications/1') {|env| [200, {}, '']}
      item = Application.new({:id=>'1'}, client)
      item.delete()
    end
  end
end
