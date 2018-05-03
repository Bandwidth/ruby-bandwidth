SendDtmf = Bandwidth::Xml::Verbs::SendDtmf
describe SendDtmf do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(SendDtmf.new(:digits => "5"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><SendDtmf>5</SendDtmf></Response>")
    end
  end
end

