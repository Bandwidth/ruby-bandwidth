SendMessage = Bandwidth::Xml::Verbs::SendMessage
describe SendMessage do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(SendMessage.new(:from => "from", :to => "to", :text => "text"))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><SendMessage from=\"from\" to=\"to\">text</SendMessage></Response>")
    end
  end
end

