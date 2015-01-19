module Bandwidth
  module ApiItem
    def initialize(data={}, client = nil)
      @client = client || Client.new()
      @data = data || {}
      data.each do |k,v|
        self.define_singleton_method(k) do
          @data[k]
        end
        self.define_singleton_method("#{k}=".to_sym()) do |val|
          @data[k] = val
        end
      end
    end
  end
end
