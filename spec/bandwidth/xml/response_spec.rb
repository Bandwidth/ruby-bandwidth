describe Bandwidth::Xml::Response do
  describe '#initialize' do
    it 'should fill @verbs' do
      expect(Xml::Response.new([1,2,3]).instance_variable_get("@verbs".to_sym())).to eql([1,2,3])
      expect(Xml::Response.new().instance_variable_get("@verbs".to_sym())).to eql([])
    end
  end

  describe '#push' do
    it 'should add verbs to @verbs' do
      r = Xml::Response.new()
      r.push(1)
      r.push(2,3,4,5).push(6)
      expect(r.instance_variable_get("@verbs".to_sym())).to eql([1,2,3,4,5,6])
    end
  end

  describe '#<<' do
    it 'should add a verb to @verbs' do
      r = Xml::Response.new()
      r << 1
      r << 2 << 3 << 4 << 5 << 6
      expect(r.instance_variable_get("@verbs".to_sym())).to eql([1,2,3,4,5,6])
    end
  end

  describe '#to_xml' do
    it 'should generate right xml text' do
      class Test
        def to_xml(xml)
          xml.Test(:test=>true)
        end
      end
      r = Xml::Response.new()
      expect(r.to_xml()).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>")
      r << Test.new()
      expect(r.to_xml()).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Test test=\"true\"/></Response>")
      r << Test.new()
      expect(r.to_xml()).to eql("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Test test=\"true\"/><Test test=\"true\"/></Response>")
    end
  end
end
