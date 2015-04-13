describe Bandwidth::Media do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return list of files' do
      client.stubs.get('/v1/users/userId/media') {|env| [200, {}, '[{"mediaName":"file1","content":"url1","contentLength":100}]']}
      expect(Media.list(client)).to eql([{:media_name => 'file1', :content => 'url1', :content_length => 100}])
    end
  end

  describe '#delete' do
    it 'should remove a file' do
      client.stubs.delete('/v1/users/userId/media/file1') {|env| [200, {}, '']}
      Media.delete(client, 'file1')
    end
  end

  describe '#download' do
    it 'should download a file' do
      client.stubs.get('/v1/users/userId/media/file1') {|env| [200, {'Content-Type' => 'text/plain'}, '123']}
      client.stubs.get('/v1/users/userId/media/file2') {|env| [200, {}, '456']}
      content, media_type = Media.download(client, 'file1')
      expect(content).to eql('123')
      expect(media_type).to eql('text/plain')
      content, media_type = Media.download(client, 'file2')
      expect(content).to eql('456')
      expect(media_type).to eql('application/octet-stream')
    end
  end

  describe '#upload' do
    it 'should upload a file' do
      client.stubs.put('/v1/users/userId/media/file1', '123', {'Content-Type' => 'text/plain', 'Content-Length' => '3'}) {|env| [200, {}, '']}
      client.stubs.put('/v1/users/userId/media/file2', '123', {'Content-Type' => 'application/octet-stream', 'Content-Length' => '3'}) {|env| [200, {}, '']}
      Media.upload(client, 'file1', StringIO.new('123'), 'text/plain')
      Media.upload(client, 'file2', StringIO.new('123'))
    end
  end

  describe '#get_info' do
    it 'should return file info' do
      client.stubs.head('/v1/users/userId/media/file1') {|env| [200, {'Content-Type' => 'application/json', 'Content-Length' => 100}, '']}
      expect(Media.get_info(client, 'file1')).to eql({:content_type => 'application/json', :content_length => 100})
    end
  end
end
