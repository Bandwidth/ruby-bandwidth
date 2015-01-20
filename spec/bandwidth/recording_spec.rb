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
      expect(Recording.get(client, '1')).to eql(template_item)
    end
  end

  describe '#list' do
    it 'should return all  recordings' do
      client.stubs.get('/v1/users/userId/recordings?page=2') {|env| [200, {}, "[#{template_json}]"]}
      expect(Recording.list(client, :page => 2)).to eql([template_item])
    end
  end
end
