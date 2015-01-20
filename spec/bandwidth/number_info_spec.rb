describe Bandwidth::NumberInfo do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return number info' do
      client.stubs.get('/v1/phoneNumbers/numberInfo/000000') {|env| [200, {}, '{"number":"000000"}']}
      expect(NumberInfo.get(client, '000000')).to eql({:number => '000000'})
    end
  end
end
