describe Bandwidth::PlayAudioExtensions do
  class Test
    include PlayAudioExtensions
    def play_audio data
      data
    end
  end
  test = Test.new()
  describe '#speak_sentence' do
    it 'should speak a sentence' do
      expect(test.speak_sentence('test', 'tag')).to eql({:gender => 'female', :locale => 'en_US', :voice => 'kate', :sentence => 'test', :tag =>'tag'})
    end
    it 'should speak a sentence (with another voice)' do
      expect(test.speak_sentence('test', 'tag', 'male', 'tom')).to eql({:gender => 'male', :locale => 'en_US', :voice => 'tom', :sentence => 'test', :tag =>'tag'})
    end
  end

  describe '#play_recording' do
    it 'should play recording' do
      expect(test.play_recording('http://host1', 'tag')).to eql({:file_url => 'http://host1', :tag => 'tag'})
    end
  end
end
