describe Bandwidth::Error do
  client = nil
  template_json = '{"id":"1","message":"message","category":"category"}'
  template_item = {:id=>'1', :message=>'message', :category=>'category'}
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return specific error' do
      client.stubs.get('/v1/users/userId/errors/1') {|env| [200, {}, template_json]}
      expect(Error.get(client, '1')).to eql(template_item)
    end
  end

  describe '#list' do
    it 'should return all  errors' do
      client.stubs.get('/v1/users/userId/errors?page=2') {|env| [200, {}, "[#{template_json}]"]}
      expect(Error.list(client, :page => 2)).to eql([template_item])
    end
  end
end
