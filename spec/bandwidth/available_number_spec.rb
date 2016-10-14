describe Bandwidth::AvailableNumber do
  client = nil
  items =  [{
    :number => "1",
    :city => "City1",
    :lata => "Lata1",
    :national_number => "NationalNumber1",
    :pattern_match => "PatternMatch1",
    :price => 0.01,
    :rate_center => "RateCenter1",
    :state => "State1"
  }, {
    :number => "2",
    :city => "City2",
    :lata => "Lata2",
    :national_number => "NationalNumber2",
    :pattern_match => "PatternMatch2",
    :price => 0.02,
    :rate_center => "RateCenter2",
    :state => "State2"
  }];

  json = Helper.camelcase(items).to_json()
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#search_toll_free' do
    it 'should return found items' do
      client.stubs.get('/v1/availableNumbers/tollFree?criteria=criteria') {|env| [200, {}, json]}
      expect(AvailableNumber.search_toll_free(client, {:criteria=>'criteria'})).to eql(items)
    end
  end

  describe '#search_local' do
    it 'should return found items' do
      client.stubs.get('/v1/availableNumbers/local?criteria=criteria') {|env| [200, {}, json]}
      expect(AvailableNumber.search_local(client, {:criteria=>'criteria'})).to eql(items)
    end
  end

  ordered_items = [
    {
      :number => "{number1}",
      :national_number => "{national_number1}",
      :price => "2.00",
      :location => "https://.../v1/users/.../phoneNumbers/numberId1"
    },
    {
      :number => "{number2}",
      :national_number => "{national_number2}",
      :price => "3.00",
      :location => "https://.../v1/users/.../phoneNumbers/numberId2"
    }
  ]

  expected_ordered_items = [
    {
      :number => '{number1}',
      :national_number => '{national_number1}',
      :price => '2.00',
      :location => 'https://.../v1/users/.../phoneNumbers/numberId1',
      :id => 'numberId1',
    },
    {
      :number => '{number2}',
      :national_number => '{national_number2}',
      :price => '3.00',
      :location => 'https://.../v1/users/.../phoneNumbers/numberId2',
      :id => 'numberId2'
    }
  ]

  ordered_json = Helper.camelcase(ordered_items).to_json()

  describe '#search_and_order_toll_free' do
    it 'should return ordered numbers' do
      client.stubs.post('/v1/availableNumbers/tollFree?criteria=criteria') {|env| [200, {}, ordered_json]}
      expect(AvailableNumber.search_and_order_toll_free(client, {:criteria=>'criteria'})).to eql(expected_ordered_items)
    end
  end

  describe '#search_and_order_local' do
    it 'should return ordered numbers' do
      client.stubs.post('/v1/availableNumbers/local?criteria=criteria') {|env| [200, {}, ordered_json]}
      expect(AvailableNumber.search_and_order_local(client, {:criteria=>'criteria'})).to eql(expected_ordered_items)
    end
  end
end
