describe Bandwidth::Bridge do
  client = nil
  template_json = '{"id":"1","state":"active"}'
  template_item = {:id=>'1', :state=>'active'}
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return specific item' do
      client.stubs.get('/v1/users/userId/bridges/1') {|env| [200, {}, template_json]}
      expect(Bridge.get(client, '1').to_data()).to eql(template_item)
    end
  end

  describe '#list' do
    it 'should return items' do
      client.stubs.get('/v1/users/userId/bridges') {|env| [200, {}, "[#{template_json}]"]}
      expect(Bridge.list(client).map {|i| i.to_data()}).to eql([template_item])
    end
  end

  describe '#create' do
    it 'should create new item' do
      client.stubs.post('/v1/users/userId/bridges', '{"bridge":"call"}') {|env| [201, {'Location' => '/v1/users/userId/bridges/1'}, '']}
      client.stubs.get('/v1/users/userId/bridges/1') {|env| [200, {}, template_json]}
      expect(Bridge.create(client, {:bridge=>'call'}).to_data()).to eql(template_item)
    end
  end

  describe '#update' do
    it 'should change item' do
      client.stubs.post('/v1/users/userId/bridges/1', '{"state":"active"}') {|env| [200, {}, '']}
      item = Bridge.new({:id=>'1'}, client)
      item.update({:state=>'active'})
    end
  end

  describe '#play_audio' do
    it 'should play audio' do
      client.stubs.post('/v1/users/userId/bridges/1/audio', '{"fileUrl":"http://host1"}') {|env| [200, {}, '']}
      item = Bridge.new({:id=>'1'}, client)
      item.play_audio(:file_url=>'http://host1')
    end
  end

  describe '#get_calls' do
    it 'should return calls of the bridge' do
      client.stubs.get('/v1/users/userId/bridges/1/calls') {|env| [200, {}, '[{"id":"1"},{"id":"2"}]']}
      item = Bridge.new({:id=>'1'}, client)
      expect(item.get_calls().map {|i| i.id}).to eql(['1', '2'])
    end
  end
end
