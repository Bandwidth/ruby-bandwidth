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
    it 'should create some items' do
      client.stubs.post('/v1/users/userId/messages', '[{"text":"hello1"},{"text":"hello2"},{"text":"hello3"}]') {|env| [200, {}, '[{"result": "accepted", "location": "/v1/users/userId/messages/1"}, {"result": "error", "error": {"message": "Error"}}, {"result": "accepted"}]']}
      r = Message.create(client, [{:text=>'hello1'}, {:text=>'hello2'}, {:text=>'hello3'}])
      puts r
      expect(r[0][:id]).to eql("1")
      expect(r[1][:error].to_s).to eql("Error")
      expect(r[2][:error]).not_to be_nil
    end
  end
end
