require_relative '../../../test_helper'

describe Bandwidth::API::PhoneNumbers do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "returns a list of allocated phone numbers" do
    @bandwidth.stub.get('/phoneNumbers') {[200, {}, <<-JSON
      [
        {
          "id": "n-6nuymbplrb3zd5yazve2ley",
          "number":"+19195551212",
          "nationalNumber":"(919) 555-1212",
          "name": "home phone",
          "createdTime": "2013-02-13T17:46:08.374Z",
          "state": "NC",
          "price": "0.60",
          "numberState": "enabled"
        },
        {
          "id": "n-8adcv3pvrdfssdfvber6rsd",
          "number":"+19195558888",
          "nationalNumber":"(919) 555-8888",
          "name": "work phone",
          "createdTime": "2013-02-13T18:32:05.223Z",
          "state": "NC",
          "price": "0.60",
          "numberState": "enabled"
        }
      ]
      JSON
    ]}

    numbers = @bandwidth.phone_numbers
    assert_equal 2, numbers.size

    number = numbers.first
    assert_equal "n-6nuymbplrb3zd5yazve2ley", number.id
    assert_equal "+19195551212", number.number
    assert_equal "(919) 555-1212", number.national_number
    assert_equal "home phone", number.name
    assert_equal "NC", number.state
  end

  it "sets id or number when allocating a number" do
    number_id = "n-6nuymbplrb3zd5yazve2ley"

    @bandwidth.stub.post('/phoneNumbers') do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal number_id, parsed_body['number']
      assert_equal nil, parsed_body['name']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/phoneNumbers/#{number_id}"}, ""]
    end

    @bandwidth.allocate_number number_id
  end

  it "sets name when allocating a number" do
    number_id = "n-6nuymbplrb3zd5yazve2ley"
    name = "home number"

    @bandwidth.stub.post('/phoneNumbers') do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal number_id, parsed_body['number']
      assert_equal name, parsed_body['name']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/phoneNumbers/#{number_id}"}, ""]
    end

    @bandwidth.allocate_number number_id, name
  end

  it "returns allocated number id" do
    number_id = "n-6nuymbplrb3zd5yazve2ley"

    @bandwidth.stub.post('/phoneNumbers') {[201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/phoneNumbers/#{number_id}"}, ""]}

    assert_equal number_id, @bandwidth.allocate_number("+19195551212")
  end

  it "returns allocated phone number information" do
    phone_number = "+19195551212"

    @bandwidth.stub.get('/phoneNumbers/+19195551212') {[200, {}, <<-JSON
      {
        "id": "n-6nuymbplrb3zd5yazve2ley",
        "number":"+19195551212",
        "nationalNumber":"(919) 555-1212",
        "name": "home phone",
        "createdTime": "2013-02-13T17:46:08.374Z",
        "state": "NC",
        "price": "0.60",
        "numberState": "enabled"
      }
      JSON
    ]}

    number = @bandwidth.phone_number_details phone_number

    assert_equal "n-6nuymbplrb3zd5yazve2ley", number.id
    assert_equal "+19195551212", number.number
    assert_equal "(919) 555-1212", number.national_number
    assert_equal "home phone", number.name
    assert_equal "NC", number.state
    assert_equal 0.60, number.price
  end

  it "removes number from account" do
    phone_number = "+19195551212"

    @bandwidth.stub.delete("/phoneNumbers/#{phone_number}") do |request|
      [200, {}, "{}"]
    end

    @bandwidth.remove_number phone_number
  end
end
