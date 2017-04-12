describe Bandwidth::V2::Message do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#create' do
    it 'should create new item' do
      client.stubs.post('/v2/users/userId/messages', '{"text":"hello"}') {|env| [202, {}, '{"id": "messageId"}']}
      expect(V2::Message.create(client, {:text=>'hello'})).to eql({id: 'messageId'})
    end
  end
end
