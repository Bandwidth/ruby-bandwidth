describe Bandwidth::PhoneNumber do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return specific item' do
      client.stubs.get('/v1/users/userId/phoneNumbers/1') {|env| [200, {}, '{"id":"1","number":"num1"}']}
      expect(PhoneNumber.get(client, '1').to_data()).to eql({:id=>'1', :number=>'num1'})
    end
  end

  describe '#list' do
    it 'should return items' do
      client.stubs.get('/v1/users/userId/phoneNumbers') {|env| [200, {}, '[{"id":"1","number":"num1"}]']}
      expect(PhoneNumber.list(client).map {|i| i.to_data()}).to eql([{:id=>'1', :number=>'num1'}])
    end
  end

  describe '#create' do
    it 'should create new item' do
      client.stubs.post('/v1/users/userId/phoneNumbers', '{"number":"num1"}') {|env| [201, {'Location' => '/v1/users/userId/phoneNumbers/1'}, '']}
      client.stubs.get('/v1/users/userId/phoneNumbers/1') {|env| [200, {}, '{"id":"1","number":"num1"}']}
      expect(PhoneNumber.create(client, {:number=>'num1'}).to_data()).to eql({:id=>'1', :number=>'num1'})
    end
  end

  describe '#update' do
    it 'should change item' do
      client.stubs.post('/v1/users/userId/phoneNumbers/1', '{"numberState":"enabled"}') {|env| [200, {}, '']}
      item = PhoneNumber.new({:id=>'1'}, client)
      item.update({:number_state=>'enabled'})
    end
  end

  describe '#delete' do
    it 'should remove item' do
      client.stubs.delete('/v1/users/userId/phoneNumbers/1') {|env| [200, {}, '']}
      item = PhoneNumber.new({:id=>'1'}, client)
      item.delete()
    end
  end
end
