Reject = Bandwidth::Xml::Verbs::Reject
describe Reject do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Reject.new(:reason => 'error'))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Reject reason=\"error\"/></Response>")
    end
  end
end

