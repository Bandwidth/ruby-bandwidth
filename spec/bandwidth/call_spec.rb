describe Bandwidth::Call do
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
      client.stubs.get('/v1/users/userId/calls/1') {|env| [200, {}, template_json]}
      expect(Call.get(client, '1').to_data()).to eql(template_item)
    end
  end

  describe '#list' do
    it 'should return items' do
      client.stubs.get('/v1/users/userId/calls') {|env| [200, {}, "[#{template_json}]"]}
      expect(Call.list(client).map {|i| i.to_data()}).to eql([template_item])
    end
  end

  describe '#create' do
    it 'should create new item' do
      client.stubs.post('/v1/users/userId/calls', '{"from":"from","to":"to"}') {|env| [201, {'Location' => '/v1/users/userId/calls/1'}, '']}
      client.stubs.get('/v1/users/userId/calls/1') {|env| [200, {}, template_json]}
      expect(Call.create(client, {:from=>'from', :to=>'to'}).to_data()).to eql(template_item)
    end
  end

  describe '#update' do
    it 'should change item' do
      client.stubs.post('/v1/users/userId/calls/1', '{"state":"active"}') {|env| [200, {}, '']}
      item = Call.new({:id=>'1'}, client)
      item.update({:state=>'active'})
    end
  end

  describe '#update (with location header)' do
    it 'should change item and return id' do
      client.stubs.post('/v1/users/userId/calls/1', '{"state":"transfering"}') {|env| [201, {'Location' => '/v1/users/userId/calls/2'}, '']}
      item = Call.new({:id=>'1'}, client)
      id = item.update({:state=>'transfering'})
      expect(id).to eql(2)
    end
  end

  describe '#play_audio' do
    it 'should play audio' do
      client.stubs.post('/v1/users/userId/calls/1/audio', '{"fileUrl":"http://host1"}') {|env| [200, {}, '']}
      item = Call.new({:id=>'1'}, client)
      item.play_audio(:file_url=>'http://host1')
    end
  end

  describe '#set_dtmf' do
    it 'should set dtmf value' do
      client.stubs.post('/v1/users/userId/calls/1/dtmf', '{"dtmfOut":"value"}') {|env| [200, {}, '']}
      item = Call.new({:id=>'1'}, client)
      item.set_dtmf('value')
    end
  end

  describe '#create_gather' do
    json =  '{"tag":"1","maxDigits":1,"prompt":{"locale":"en_US","gender":"female","sentence":"test","voice":"kate","bargeable":true}}'
    it 'should create a gather' do
      client.stubs.post('/v1/users/userId/calls/1/gather', json) {|env| [200, {'Location' => '/v1/users/userId/calls/1/gather/10'}, '']}
      client.stubs.get('/v1/users/userId/calls/1/gather/10') {|env| [200, {}, '{"id": "10"}']}
      item = Call.new({:id=>'1'}, client)
      data = {:tag => "1", :maxDigits => 1, :prompt => {:locale => "en_US", :gender => "female", :sentence => "test", :voice => "kate", :bargeable => true}}
      expect(item.create_gather(data)[:id]).to eql('10')
    end
    it 'should create a gather by sentence sting only' do
      client.stubs.post('/v1/users/userId/calls/1/gather', json) {|env| [200, {'Location' => '/v1/users/userId/calls/1/gather/10'}, '']}
      client.stubs.get('/v1/users/userId/calls/1/gather/10') {|env| [200, {}, '{"id": "10"}']}
      item = Call.new({:id=>'1'}, client)
      expect(item.create_gather('test')[:id]).to eql('10')
    end
  end

  describe '#update_gather' do
    it 'should update a gather' do
      client.stubs.post('/v1/users/userId/calls/1/gather/10', '{"state":"completed"}') {|env| [201, {}, '']}
      item = Call.new({:id=>'1'}, client)
      item.update_gather('10', {:state => 'completed'})
    end
  end

  describe '#get_gather' do
    it 'should return a gather' do
      client.stubs.get('/v1/users/userId/calls/1/gather/10') {|env| [200, {}, '{"id": "10"}']}
      item = Call.new({:id=>'1'}, client)
      expect(item.get_gather('10')[:id]).to eql('10')
    end
  end

  describe '#get_event' do
    it 'should return a event' do
      client.stubs.get('/v1/users/userId/calls/1/events/10') {|env| [200, {}, '{"id": "10"}']}
      item = Call.new({:id=>'1'}, client)
      expect(item.get_event('10')[:id]).to eql('10')
    end
  end

  describe '#get_events' do
    it 'should return events of a call' do
      client.stubs.get('/v1/users/userId/calls/1/events') {|env| [200, {}, '[{"id": "10"},{"id": "11"}]']}
      item = Call.new({:id=>'1'}, client)
      expect(item.get_events().map {|i| i[:id]}).to eql(['10', '11'])
    end
  end

  describe '#get_recording' do
    it 'should return recordings of a call' do
      client.stubs.get('/v1/users/userId/calls/1/recordings') {|env| [200, {}, '[{"id": "10"},{"id": "11"}]']}
      item = Call.new({:id=>'1'}, client)
      expect(item.get_recordings().map {|i| i[:id]}).to eql(['10', '11'])
    end
  end

  describe '#hangup' do
    it 'should hang up a call' do
      client.stubs.post('/v1/users/userId/calls/1', '{"state":"completed"}') {|env| [200, {}, '']}
      client.stubs.get('/v1/users/userId/calls/1') {|env| [200, {}, '{"state": "completed"}']}
      item = Call.new({:id=>'1', :state=>'active'}, client)
      item.hangup()
      expect(item.state).to eql('completed')
    end
  end

  describe '#answer_on_incoming' do
    it 'should answer on an incoming call' do
      client.stubs.post('/v1/users/userId/calls/1', '{"state":"active"}') {|env| [200, {}, '']}
      client.stubs.get('/v1/users/userId/calls/1') {|env| [200, {}, '{"state": "active"}']}
      item = Call.new({:id=>'1', :state=>'active'}, client)
      item.answer_on_incoming()
      expect(item.state).to eql('active')
    end
  end

  describe '#reject_incoming' do
    it 'should reject  an incoming call' do
      client.stubs.post('/v1/users/userId/calls/1', '{"state":"rejected"}') {|env| [200, {}, '']}
      client.stubs.get('/v1/users/userId/calls/1') {|env| [200, {}, '{"state": "rejected"}']}
      item = Call.new({:id=>'1', :state=>'active'}, client)
      item.reject_incoming()
      expect(item.state).to eql('rejected')
    end
  end

  describe '#recording_on' do
    it 'should tune on recording of a call' do
      client.stubs.post('/v1/users/userId/calls/1', '{"recordingEnabled":true}') {|env| [200, {}, '']}
      client.stubs.get('/v1/users/userId/calls/1') {|env| [200, {}, '{"recordingEnabled":true}']}
      item = Call.new({:id=>'1', :recording_enabled=>false}, client)
      item.recording_on()
      expect(item.recording_enabled).to eql(true)
    end
  end

  describe '#recording_off' do
    it 'should tune off recording of a call' do
      client.stubs.post('/v1/users/userId/calls/1', '{"recordingEnabled":false}') {|env| [200, {}, '']}
      client.stubs.get('/v1/users/userId/calls/1') {|env| [200, {}, '{"recordingEnabled":false}']}
      item = Call.new({:id=>'1', :recording_enabled=>true}, client)
      item.recording_off()
      expect(item.recording_enabled).to eql(false)
    end
  end
end
