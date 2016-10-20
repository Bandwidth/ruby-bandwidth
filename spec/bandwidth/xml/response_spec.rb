describe Bandwidth::Xml::Response do
  it 'should build BXML via builder' do
    response = Xml::Response.new do |r|
      r.Call from: "from", to: "to"
      r.SpeakSentence "Hello"
    end
    expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Call from=\"from\" to=\"to\"/><SpeakSentence>Hello</SpeakSentence></Response>"
    expect(response.text).to eql(expected)
  end
end
