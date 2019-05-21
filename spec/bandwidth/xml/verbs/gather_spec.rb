Gather = Bandwidth::Xml::Verbs::Gather
describe Gather do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Gather.new(:request_url => "http://localhost"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Gather requestUrl=\"http://localhost\"></Gather></Response>")
      expect(Helper.to_xml(Gather.new(:request_url => "http://localhost", :max_digits => 2))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Gather requestUrl=\"http://localhost\" maxDigits=\"2\"></Gather></Response>")
    end
  end
end

