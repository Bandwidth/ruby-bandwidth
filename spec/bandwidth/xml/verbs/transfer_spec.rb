Transfer = Bandwidth::Xml::Verbs::Transfer
describe Transfer do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Transfer.new(:transfer_to => "to", :transfer_caller_id => "id"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"></Transfer></Response>")
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"></Transfer></Response>")
    end
    it 'should allow to embed SpeakSentence' do
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id", :speak_sentence => {:voice => "kate", :sentence => "text"}))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"><SpeakSentence voice=\"kate\">text</SpeakSentence></Transfer></Response>")
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id", :speak_sentence => SpeakSentence.new({:voice => "kate", :sentence => "text"})))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"><SpeakSentence voice=\"kate\">text</SpeakSentence></Transfer></Response>")
    end
  end
end

