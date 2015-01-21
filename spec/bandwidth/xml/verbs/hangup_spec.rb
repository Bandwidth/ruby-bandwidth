Hangup = Bandwidth::Xml::Verbs::Hangup
describe Hangup do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Hangup.new())).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Hangup/></Response>")
    end
  end
end

