module Bandwidth
  # Module which adds common operations for all Catapult api related classes
  module ApiItem
    # Initializer
    #
    # @param data [Hash] Hash with data of api item. Initializer will create accessors for each key of this hash
    # @param client [Client] Optional client instance. If omitted Client instance with default parameters will be used
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

    # Return data of api item as hash
    def to_data()
      @data.clone()
    end
  end
end
