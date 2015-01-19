describe Bandwidth::Errors do
  describe Bandwidth::Errors::GenericError do
    it 'should return code and message fields' do
      error = Bandwidth::Errors::GenericError.new('10', 'Error')
      expect(error.code).to eql('10')
      expect(error.message).to eql('Error')
    end
  end
end
