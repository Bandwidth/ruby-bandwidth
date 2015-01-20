describe Bandwidth::ConferenceMember do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#update' do
    it 'should change item' do
      client.stubs.post('/v1/users/userId/conferences/1/members/10', '{"mute":true}') {|env| [200, {}, '']}
      item = ConferenceMember.new({:id=>'10'}, client)
      item.conference_id = '1'
      item.update({:mute=>true})
    end
  end

  describe '#play_audio' do
    it 'should play audio' do
      client.stubs.post('/v1/users/userId/conferences/1/members/10/audio', '{"fileUrl":"http://host1"}') {|env| [200, {}, '']}
      item = ConferenceMember.new({:id=>'10'}, client)
      item.conference_id = '1'
      item.play_audio(:file_url=>'http://host1')
    end
  end
end
