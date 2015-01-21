Redirect = Bandwidth::Xml::Verbs::Redirect
describe Redirect do
  describe '#to_xml' do
    it 'should generate valid xml' do
      expect(Helper.to_xml(Redirect.new(:request_url => 'url'))).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Redirect requestUrl=\"url\"/></Response>")
    end
  end
end

