SpeakSentence = Bandwidth::Xml::Verbs::SpeakSentence
describe SpeakSentence do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(SpeakSentence.new(:voice => "kate", :sentence => "text"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><SpeakSentence voice=\"kate\" gender=\"female\">text</SpeakSentence></Response>")
    end
  end
end

