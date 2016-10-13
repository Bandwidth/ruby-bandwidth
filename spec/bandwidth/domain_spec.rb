describe Bandwidth::Domain do
  client = nil
  template_json = '{"id":"1","name":"domain1","description":"description"}'
  template_item = {:id=>'1', :name=>'domain1', :description=>'description'}
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return list' do
      client.stubs.get('/v1/users/userId/domains') {|env| [200, {}, "[#{template_json}]"]}
      expect(Domain.list(client).map {|i| i.to_data()}).to eql([template_item])
    end
  end


  describe '#create' do
    it 'should create new item' do
      client.stubs.post('/v1/users/userId/domains', '{"name":"domain1","description":"description"}') {|env| [201, {'Location' => '/v1/users/userId/domains/1'}, '']}
      expect(Domain.create(client, {:name=>'domain1', :description=>'description'}).to_data()).to eql(template_item)
    end
  end

  describe '#delete' do
    it 'should remove item' do
      client.stubs.delete('/v1/users/userId/domains/1') {|env| [200, {}, '']}
      item = Domain.new({:id=>'1'}, client)
      item.delete()
    end
  end

  describe '#create_endpoint' do
    it 'should create a endpoint' do
      client.stubs.post('/v1/users/userId/domains/1/endpoints', '{"name":"point1"}') {|env| [200, {'Location' => '/v1/users/userId/domains/1/endpoints/10'}, '']}
      item = Domain.new({:id=>'1'}, client)
      expect(item.create_endpoint(:name=> 'point1').id).to eql('10')
    end
  end

  describe '#get_endpoint' do
    it 'should return a endpoint' do
      client.stubs.get('/v1/users/userId/domains/1/endpoints/10') {|env| [200, {}, '{"id": "10"}']}
      item = Domain.new({:id=>'1'}, client)
      expect(item.get_endpoint('10').id).to eql('10')
    end
  end

  describe '#get_endpoints' do
    it 'should return endpoints of a domain' do
      client.stubs.get('/v1/users/userId/domains/1/endpoints') {|env| [200, {}, '[{"id": "10"},{"id": "11"}]']}
      item = Domain.new({:id=>'1'}, client)
      expect(item.get_endpoints().map {|i| i.id}).to eql(['10', '11'])
    end
  end

  describe '#delete_endpoint' do
    it 'should remove a endpoint' do
      client.stubs.delete('/v1/users/userId/domains/1/endpoints/10') {|env| [200, {}, '']}
      item = Domain.new({:id=>'1'}, client)
      item.delete_endpoint('10')
    end
  end
end
