Record = Bandwidth::Xml::Verbs::Record
describe Record do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Record.new(:max_duration => 10))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Record maxDuration=\"10\"/></Response>")
    end
  end
end

