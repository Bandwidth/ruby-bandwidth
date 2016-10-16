describe Bandwidth::LazyInstance do
  it 'should return instance on demand' do
    callCount = 0
    instance = Bandwidth::LazyInstance.new('id', lambda {
      callCount = callCount + 1
      '123'
    })
    expect(callCount).to eql(0)
    expect(instance.id).to eql('id')
    expect(callCount).to eql(0)
    expect(instance.size).to eql(3)
    expect(callCount).to eql(1)
  end

  it 'should call get_instance only one time' do
    callCount = 0
    instance = Bandwidth::LazyInstance.new('id', lambda {
      callCount = callCount + 1
      '123'
    })
    expect(callCount).to eql(0)
    expect(instance.size).to eql(3)
    expect(callCount).to eql(1)
    expect(instance.size).to eql(3)
    expect(callCount).to eql(1)
  end

  it 'should support calss via []' do
    instance = Bandwidth::LazyInstance.new('id', lambda { {name: 'Name'} })
    expect(instance[:id]).to eql('id')
    expect(instance[:name]).to eql('Name')
  end

end
