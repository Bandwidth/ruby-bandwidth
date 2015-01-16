require 'helper'

describe Bandwidth::Client do
  describe '#initialize' do
    it 'should create instance of Client' do
      expect(Client.new()).to be_a(Client)
      expect(Client.new('userId', 'token', 'secret')).to be_a(Client)
      expect(Client.new('userId', 'token', 'secret', 'endpoint', 'version')).to be_a(Client)
      expect(Client.new({:user_id => 'userId', :api_token => 'token', :secret => 'secret'})).to be_a(Client)
    end
  end

  describe '#global_options' do
    it 'should return and change @@global_options of Client' do
      Client.global_options = {:user_id => 'User', :api_token => 'token', :secret => 'secret'}
      expect(Client.global_options).to eql({:user_id => 'User', :api_token => 'token', :secret => 'secret'})
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
    before do
      client = Helper.get_client()
    end

#    it 'should make GET request and return json data' do
#      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
#        stub.get('/v1/path1') { |env| [200, {}, '{"test": "data"}'] }
#      end
#      expect(client.make_request(:get, 'path1')).to eql(:test => 'data')
#      stubs.verify_stubbed_calls()
#    end
  end
end
