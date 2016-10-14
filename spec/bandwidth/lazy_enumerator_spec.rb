describe Bandwidth::LazyEnumerator do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  it 'should return enumerable with values' do
    list = Bandwidth::LazyEnumerator.new(lambda {[[1, 2, 3], {}]}, client).to_a
    expect(list.size).to eql(3)
    expect(list).to match_array([1, 2, 3])
  end

  it 'should return enumerable with values and block' do
    list = Bandwidth::LazyEnumerator.new(lambda {[[1, 2, 3], {}]}, client) do |yielder, item|
      yielder << item + 10
    end.to_a
    expect(list.size).to eql(3)
    expect(list).to match_array([11, 12, 13])
  end

  it 'should require data on demand' do
    called = false
    list = Bandwidth::LazyEnumerator.new(lambda do
      called = true
      [[1, 2, 3], {}]
    end, client)
    expect(called).to be false
    list.to_a
    expect(called).to be true
  end

  it 'should handle header "Link"' do
    list = Bandwidth::LazyEnumerator.new(lambda {[[1, 2, 3], {
        link: '<https://api.catapult.inetwork.com/v1/users/userId/account/transactions?page=0&size=25>; rel="first"'
      }]}, client).to_a
    expect(list).to match_array([1, 2, 3])
  end

  it 'should handle next page' do
    client.stubs.get('/v1/users/userId/account/transactions?page=1&size=25') {|env| [200, {}, '[4, 5, 6]']}
    list = Bandwidth::LazyEnumerator.new(lambda {[[1, 2, 3], {
        link: '<https://api.catapult.inetwork.com/v1/users/userId/account/transactions?page=0&size=25>; rel="first", <https://api.catapult.inetwork.com/v1/users/userId/account/transactions?page=1&size=25>; rel="next"'
      }]}, client).to_a
    expect(list).to match_array([1, 2, 3, 4, 5, 6])
  end
end
