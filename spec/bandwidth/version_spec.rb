require 'helper'

describe Bandwidth::VERSION do
  it 'should return version of this gem' do
    expect(Bandwidth::VERSION).to_not be_nil
  end
end
