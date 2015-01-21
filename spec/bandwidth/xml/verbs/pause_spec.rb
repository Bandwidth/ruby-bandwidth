Pause = Bandwidth::Xml::Verbs::Pause
describe Pause do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Pause.new(:duration => 10))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Pause duration=\"10\"/></Response>")
    end
  end
end

