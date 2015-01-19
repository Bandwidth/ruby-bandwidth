describe Bandwidth::ClientWrapper do
  describe 'wrap_client_arg' do
    it 'should pass Client instance to method as first arg if it is missing' do
      class Test
        def self.foo(client, arg1, arg2)
          ["test", client, arg1, arg2]
        end
        extend Bandwidth::ClientWrapper
        wrap_client_arg :foo
      end
      client = Client.new()
      r = Test.foo(client, 1, [1,2,3])
      expect(r[0]).to eql("test")
      expect(r[1]).to be_a(Client)
      expect(r[1]).to be(client)
      expect(r[2]).to eql(1)
      expect(r[3]).to eql([1,2,3])
      r = Test.foo(2, [10,20,30])
      expect(r[0]).to eql("test")
      expect(r[1]).to be_a(Client)
      expect(r[1]).to_not be(client)
      expect(r[2]).to eql(2)
      expect(r[3]).to eql([10,20,30])
    end
  end
end
