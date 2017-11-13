Transfer = Bandwidth::Xml::Verbs::Transfer
describe Transfer do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Transfer.new(:transfer_to => "to", :transfer_caller_id => "id"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"></Transfer></Response>")
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"></Transfer></Response>")
    end
    it 'should allow to embed SpeakSentence' do
      result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"><SpeakSentence voice=\"kate\" gender=\"female\">text</SpeakSentence></Transfer></Response>"
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id", :speak_sentence => {:voice => "kate", :sentence => "text"}))).to eql(result)
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id", :speak_sentence => SpeakSentence.new({:voice => "kate", :sentence => "text"})))).to eql(result)
    end
    it 'should allow to embed PlayAudio' do
      result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"><PlayAudio>url1</PlayAudio></Transfer></Response>"
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id", :play_audio => {:url =>"url1"}))).to eql(result)
    end
    it 'should allow to embed Record' do
      result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"><Record requestUrl=\"url1\"/></Transfer></Response>"
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id", :record => {:request_url =>"url1"}))).to eql(result)
    end
    it 'should allow to embed phone numbers' do
      result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"><PhoneNumber>+1234568901</PhoneNumber><PhoneNumber>+1234568902</PhoneNumber></Transfer></Response>"
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id", :phone_numbers => ["+1234568901", "+1234568902"]))).to eql(result)
      result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Transfer transferTo=\"to\" transferCallerId=\"id\"><PhoneNumber>+1234568901</PhoneNumber></Transfer></Response>"
      expect(Helper.to_xml(Transfer.new(:to => "to", :caller_id => "id", :phone_number => "+1234568901"))).to eql(result)
    end
  end
end

