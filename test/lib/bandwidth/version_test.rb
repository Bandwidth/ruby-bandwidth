require_relative '../../test_helper'

describe Bandwidth do
  it "VERSION must be defined" do
    Bandwidth::VERSION.wont_be_nil
  end
end
