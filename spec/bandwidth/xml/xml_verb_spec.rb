describe Bandwidth::Xml::XmlVerb do
  class Test
    include Xml::XmlVerb
  end
  it 'should generate read/write accessors for data' do
    item = Test.new({:field1 => 'test1', :field2 => 'test2'})
    expect(item.field1).to eql('test1')
    expect(item.field2).to eql('test2')
    item.field1 = 'new value'
    expect(item.field1).to eql('new value')
    expect(item.unknown_field).to be_nil
    item = Test.new()
    item.field1 = 'new value'
    expect(item.field1).to eql('new value')
  end
  describe '#compact_hash' do
    it 'should remove keys with nil values from hash' do
      item = Test.new()
      data = {:n1 => 1, :n2 => nil, :n3 => {:m1 => 3, :m2 => nil, :m3 => '4'}}
      expect(item.compact_hash(data)).to eql({:n1 => 1, :n3 => {:m1 => 3, :m3 => '4'}})
    end
  end
end
