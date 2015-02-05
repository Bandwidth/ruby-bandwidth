describe Bandwidth::ApiItem do
  class TestItem
    include ApiItem
  end
  describe '#initialize' do
    it 'should add method initialze' do
      expect(TestItem.private_method_defined?(:initialize)).to eql(true)
    end

    it 'should add read/write properties for each key in data' do
      client = Client.new()
      item = TestItem.new({:name => 'Name', :value => 10}, client)
      expect(item.name).to eql('Name')
      expect(item.value).to eql(10)
      item.name = 'Another name'
      item.value = 11
      expect(item.name).to eql('Another name')
      expect(item.value).to eql(11)
    end

    it 'should create client instance if need' do
      client = Client.new()
      item = TestItem.new({}, client)
      expect(item.instance_variable_get(:@client)).to be(client)
      item = TestItem.new({})
      c = item.instance_variable_get(:@client)
      expect(c).to_not be(client)
      expect(c).to be_a(Client)
    end
  end

  describe '#to_data' do
    it 'should return @data field' do
      data = {:test => true}
      item = TestItem.new(data)
      expect(item.to_data()).to eql(data)
    end
  end

  describe '#[]' do
    it 'should return item of @data by key' do
      data = {:test => true}
      item = TestItem.new(data)
      expect(item[:test]).to eql(true)
    end
  end

  describe '#[]=' do
    it 'should change value of  item of @data by key' do
      data = {:test => true}
      item = TestItem.new(data)
      expect(item[:test]).to eql(true)
      item[:test] = false
      expect(item[:test]).to eql(false)
    end
  end
end
