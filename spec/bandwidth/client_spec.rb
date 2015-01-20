require 'base64'

describe Bandwidth::Client do
  describe '#initialize' do
    it 'should create instance of Client' do
      expect(Client.new()).to be_a(Client)
      expect(Client.new('userId', 'token', 'api_secret')).to be_a(Client)
      expect(Client.new('userId', 'token', 'api_secret', 'endpoint', 'version')).to be_a(Client)
      expect(Client.new({:user_id => 'userId', :api_token => 'token', :api_secret => 'api_secret'})).to be_a(Client)
    end
  end

  describe '#global_options' do
    it 'should return and change @@global_options of Client' do
      Client.global_options = {:user_id => 'User', :api_token => 'token', :api_secret => 'api_secret'}
      expect(Client.global_options).to eql({:user_id => 'User', :api_token => 'token', :api_secret => 'api_secret'})
    end
  end

  describe '#get_id_from_location_header' do
    it 'should return last url path item as id' do
      expect(Client.get_id_from_location_header('http://localhost/path1/path2/id')).to eql('id')
    end
    it 'should raise error if location is missing or nil' do
      expect{Client.get_id_from_location_header('')}.to raise_error
      expect{Client.get_id_from_location_header(nil)}.to raise_error
    end
  end

  describe '#make_request' do
    client = nil
    before :each do
      client = Helper.get_client()
    end

    after :each do
      client.stubs.verify_stubbed_calls()
    end

    it 'should make GET request and return json data' do
      client.stubs.get('/v1/path1') { |env| [200, {}, '{"test": "data"}'] }
      client.stubs.get('/v1/path2?testField=10') { |env| [200, {'Location'=>'url'}, '{"testValue": 10, "dataArray": [1,2,3]}'] }
      expect(client.make_request(:get, '/path1')).to eql([{:test => 'data'}, {}])
      expect(client.make_request(:get, '/path2', {:test_field => 10})).to eql([{:test_value => 10, :data_array => [1, 2, 3]}, {:location=>'url'}])
    end

    it 'should make POST request and return json data' do
      client.stubs.post('/v1/path1', '{"testField":true}') { |env|  [200, {}, '{"success": true}'] }
      expect(client.make_request(:post, '/path1', {:test_field => true})[0]).to eql(:success => true)
    end

    it 'should make PUT request and return json data' do
      client.stubs.put('/v1/path1', '{"testField":[{"item":1},{"item":2}]}') { |env|  [200, {}, '{"resultItems": [{"r": 10}, {"r": 20}]}'] }
      expect(client.make_request(:put, '/path1', {:test_field => [{:item => 1}, {:item => 2}]})[0]).to eql(:result_items => [{:r=>10}, {:r=>20}])
    end

    it 'should make DELETE request and return json data' do
      client.stubs.delete('/v1/path1') { |env| [200, {}, '{"test": "data"}'] }
      expect(client.make_request(:delete, '/path1')[0]).to eql(:test => 'data')
    end

    it 'should raise error if http status >= 400' do
      client.stubs.get('/v1/path1') { |env| [400, {}, '{"code": "code", "message": "error"}'] }
      expect{client.make_request(:get, '/path1')}.to raise_error(Errors::GenericError, "error")
    end
  end

  describe '#concat_user_path' do
    client = nil
    before :each do
      client = Helper.get_client()
    end

    it 'should add user id to path' do
      expect(client.concat_user_path('test')).to eql('/users/userId/test')
      expect(client.concat_user_path('/test1')).to eql('/users/userId/test1')
    end
  end


  describe '#create_connection' do
    client = nil
    before :each do
      client = Helper.get_client()
    end

    it 'should create new faraday connection' do
      connection = client.create_connection()
      expect(connection).to be_a(Faraday::Connection)
      expect(connection.headers['Authorization']).to eql("Basic #{Base64.strict_encode64('token:secret')}")
    end
  end
end
