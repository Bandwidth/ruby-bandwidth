describe Bandwidth::Message do
  client = nil
  template_json = '{"id":"1","from":"from","to":"to","text":"text"}'
  template_item = {:id=>'1', :from=>'from', :to=>'to', :text=>'text'}
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return specific item' do
      client.stubs.get('/v1/users/userId/messages/1') {|env| [200, {}, template_json]}
      expect(Message.get(client, '1')).to eql(template_item)
    end
  end

  describe '#list' do
    it 'should return items' do
      client.stubs.get('/v1/users/userId/messages') {|env| [200, {}, "[#{template_json}]"]}
      expect(Message.list(client)).to eql([template_item])
    end
  end

  describe '#create' do
    it 'should create new item' do
      client.stubs.post('/v1/users/userId/messages', '{"text":"hello"}') {|env| [201, {'Location' => '/v1/users/userId/messages/1'}, '']}
      client.stubs.get('/v1/users/userId/messages/1') {|env| [200, {}, template_json]}
      expect(Message.create(client, {:text=>'hello'})).to eql(template_item)
    end
  end
end
