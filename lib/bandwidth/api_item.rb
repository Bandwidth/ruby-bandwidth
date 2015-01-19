module Bandwidth
  module ApiItem
    def initialize(data={}, client = nil)
      @client = client || Client.new()
      @data = (data || {}).clone()
      @data.each do |k,v|
        self.define_singleton_method(k) do
          @data[k]
        end
        self.define_singleton_method("#{k}=".to_sym()) do |val|
          @data[k] = val
        end
      end
    end

    def to_data()
      @data.clone()
    end
  end
end
