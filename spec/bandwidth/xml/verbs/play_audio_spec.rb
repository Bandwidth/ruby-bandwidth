PlayAudio = Bandwidth::Xml::Verbs::PlayAudio
describe PlayAudio do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(PlayAudio.new(:url => 'url', :digits => '2'))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><PlayAudio digits=\"2\">url</PlayAudio></Response>")
      expect(Helper.to_xml(PlayAudio.new(:url => 'url'))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><PlayAudio>url</PlayAudio></Response>")
    end
  end
end

