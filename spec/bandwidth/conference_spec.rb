describe Bandwidth::Conference do
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
      client.stubs.get('/v1/users/userId/conferences/1') {|env| [200, {}, template_json]}
      expect(Conference.get(client, '1').to_data()).to eql(template_item)
    end
  end


  describe '#create' do
    it 'should create new item' do
      client.stubs.post('/v1/users/userId/conferences', '{"from":"from","callbackUrl":"url"}') {|env| [201, {'Location' => '/v1/users/userId/conferences/1'}, '']}
      client.stubs.get('/v1/users/userId/conferences/1') {|env| [200, {}, template_json]}
      expect(Conference.create(client, {:from=>'from', :callback_url=>'url'}).to_data()).to eql(template_item)
    end
  end

  describe '#update' do
    it 'should change item' do
      client.stubs.post('/v1/users/userId/conferences/1', '{"callbackUrl":"url2"}') {|env| [200, {}, '']}
      item = Conference.new({:id=>'1'}, client)
      item.update({:callback_url=>'url2'})
    end
  end

  describe '#mute' do
    it 'should call mute' do
      client.stubs.post('/v1/users/userId/conferences/1', '{"mute":true}') {|env| [200, {}, '']}
      item = Conference.new({:id=>'1'}, client)
      item.mute()
    end
  end

  describe '#complete' do
    it 'should complete a conference' do
      client.stubs.post('/v1/users/userId/conferences/1', '{"state":"completed"}') {|env| [200, {}, '']}
      item = Conference.new({:id=>'1'}, client)
      item.complete()
    end
  end

  describe '#play_audio' do
    it 'should play audio' do
      client.stubs.post('/v1/users/userId/conferences/1/audio', '{"fileUrl":"http://host1"}') {|env| [200, {}, '']}
      item = Conference.new({:id=>'1'}, client)
      item.play_audio(:file_url=>'http://host1')
    end
  end

  describe '#create_member' do
    it 'should create a member' do
      client.stubs.post('/v1/users/userId/conferences/1/members', '{"from":"from"}') {|env| [200, {'Location' => '/v1/users/userId/conferences/1/members/10'}, '']}
      item = Conference.new({:id=>'1'}, client)
      expect(item.create_member(:from => 'from').id).to eql('10')
    end
  end

  describe '#get_member' do
    it 'should return a member' do
      client.stubs.get('/v1/users/userId/conferences/1/members/10') {|env| [200, {}, '{"id": "10"}']}
      item = Conference.new({:id=>'1'}, client)
      expect(item.get_member('10').id).to eql('10')
    end
  end

  describe '#get_members' do
    it 'should return members of a conference' do
      client.stubs.get('/v1/users/userId/conferences/1/members') {|env| [200, {}, '[{"id": "10"},{"id": "11"}]']}
      item = Conference.new({:id=>'1'}, client)
      expect(item.get_members().map {|i| i.id}).to eql(['10', '11'])
    end
  end
end
