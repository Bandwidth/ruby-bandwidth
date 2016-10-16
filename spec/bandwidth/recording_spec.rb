describe Bandwidth::Recording do
  client = nil
  template_json = '{"id":"1","call":"call","media":"media"}'
  template_item = {:id=>'1', :call=>'call', :media=>'media'}
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return specific recording' do
      client.stubs.get('/v1/users/userId/recordings/1') {|env| [200, {}, template_json]}
      expect(Recording.get(client, '1').to_data()).to eql(template_item)
    end
  end

  describe '#list' do
    it 'should return all  recordings' do
      client.stubs.get('/v1/users/userId/recordings?page=2') {|env| [200, {}, "[#{template_json}]"]}
      expect(Recording.list(client, :page => 2).map {|i| i.to_data()}).to eql([template_item])
    end
  end

  describe '#create_transcription' do
    it 'should create a transcription' do
      client.stubs.post('/v1/users/userId/recordings/1/transcriptions') {|env|
        [200, {'Location' => '/v1/users/userId/recordings/1/transcriptions/10'}, '']}
      item = Recording.new({:id=>'1'}, client)
      expect(item.create_transcription()[:id]).to eql('10')
    end
  end

  describe '#get_transcription' do
    it 'should return a transcription' do
      client.stubs.get('/v1/users/userId/recordings/1/transcriptions/10') {|env| [200, {}, '{"id": "10"}']}
      item = Recording.new({:id=>'1'}, client)
      expect(item.get_transcription('10')[:id]).to eql('10')
    end
  end

  describe '#get_transcriptions' do
    it 'should return transcriptions of a recording' do
      client.stubs.get('/v1/users/userId/recordings/1/transcriptions') {|env| [200, {}, '[{"id": "10"},{"id": "11"}]']}
      item = Recording.new({:id=>'1'}, client)
      expect(item.get_transcriptions().map {|i| i[:id]}).to eql(['10', '11'])
    end
  end
end
