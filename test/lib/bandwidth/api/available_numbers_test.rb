require_relative '../../../test_helper'

describe Bandwidth::API::AvailableNumbers do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "returns a list of available local numbers" do
    @bandwidth.stub.get('/availableNumbers/local') {[200, {}, <<-JSON
      [
        {
          "number": "+19192972390",
          "nationalNumber": "(919) 297-2390",
          "patternMatch": "          2 9 ",
          "city": "CARY",
          "lata": "426",
          "rateCenter": "CARY",
          "state": "NC"
        },
        {
          "number": "+19192972393",
          "nationalNumber": "(919) 297-2393",
          "patternMatch": "          2 9 ",
          "city": "CARY",
          "lata": "426",
          "rateCenter": "CARY",
          "state": "NC"
        }
      ]
      JSON
    ]}

    numbers = @bandwidth.available_numbers
    assert_equal 2, numbers.size

    number = numbers.first
    assert_equal "+19192972390", number.number
    assert_equal "(919) 297-2390", number.national_number
    assert_equal "          2 9 ", number.pattern_match
    assert_equal "CARY", number.city
    assert_equal "NC", number.state
  end

  it "returns a list of available toll free numbers" do
    @bandwidth.stub.get('/availableNumbers/tollFree') {[200, {}, <<-JSON
      [
        {
          "number":"+18557626967",
          "nationalNumber":"(855) 762-6967",
          "patternMatch":"        2  9  ",
          "price":"2.00"
        },
        {
          "number":"+18557712996",
          "nationalNumber":"(855) 771-2996",
          "patternMatch":"          2 9 ",
          "price":"2.00"
        }
      ]
      JSON
    ]}

    numbers = @bandwidth.available_toll_free_numbers
    assert_equal 2, numbers.size

    number = numbers.first
    assert_equal "+18557626967", number.number
    assert_equal "(855) 762-6967", number.national_number
    assert_equal "        2  9  ", number.pattern_match
    assert_equal 2.00, number.price
  end

  it "passes filtering to available numbers: zip" do
    zip = "12345"

    @bandwidth.stub.get('/availableNumbers/local') do |request|
      assert_equal zip, request[:params]['zip']

      [200, {}, "{}"]
    end

    @bandwidth.available_numbers zip: zip
  end

  it "passes filtering to available numbers: state" do
    state = "CA"

    @bandwidth.stub.get('/availableNumbers/local') do |request|
      assert_equal state, request[:params]['state']

      [200, {}, "{}"]
    end

    @bandwidth.available_numbers state: state
  end

  it "passes filtering to available numbers: area code" do
    area_code = "919"

    @bandwidth.stub.get('/availableNumbers/local') do |request|
      assert_equal area_code, request[:params]['areaCode']

      [200, {}, "{}"]
    end

    @bandwidth.available_numbers area_code: area_code
  end

  it "passes filtering to available numbers: city" do
    city = "Cary"

    @bandwidth.stub.get('/availableNumbers/local') do |request|
      assert_equal city, request[:params]['city']

      [200, {}, "{}"]
    end

    @bandwidth.available_numbers city: city
  end

  it "passes filtering to available numbers: pattern" do
    pattern = "*2?9*"

    @bandwidth.stub.get('/availableNumbers/local') do |request|
      assert_equal pattern, request[:params]['pattern']

      [200, {}, "{}"]
    end

    @bandwidth.available_numbers pattern: pattern
  end

  it "passes filtering to available toll free numbers: pattern" do
    pattern = "*2?9*"

    @bandwidth.stub.get('/availableNumbers/tollFree') do |request|
      assert_equal pattern, request[:params]['pattern']

      [200, {}, "{}"]
    end

    @bandwidth.available_toll_free_numbers pattern: pattern
  end

  it "raises exception when more than one of: zip, state or area code is passed" do
    assert_raises ArgumentError, "ZIP code, state and area code are mutually exclusive" do
      @bandwidth.available_numbers zip: '12345', state: 'NY'
    end
    assert_raises ArgumentError, "ZIP code, state and area code are mutually exclusive" do
      @bandwidth.available_numbers zip: '12345', area_code: '919'
    end
    assert_raises ArgumentError, "ZIP code, state and area code are mutually exclusive" do
      @bandwidth.available_numbers state: 'CA', area_code: '919'
    end
  end

  it "raises exception when there are incompatible options" do
    assert_raises ArgumentError, "Unknown option passed: [:unknown_option]" do
      @bandwidth.available_numbers unknown_option: 'some value'
    end
    assert_raises ArgumentError, "Unknown option passed: [:unknown_option]" do
      @bandwidth.available_toll_free_numbers unknown_option: 'some value'
    end
  end
end
