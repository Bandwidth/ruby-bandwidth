Dtmf = Bandwidth::Xml::Verbs::Dtmf
describe Dtmf do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Dtmf.new(:digits => "5"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><DTMF>5</DTMF></Response>")
    end
  end
end

