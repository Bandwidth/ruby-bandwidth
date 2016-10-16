module Bandwidth
  # LazyInstance will return data on demand
  class LazyInstance
    attr_reader :id

    # Initializer
    # @param id [String] Id of instance
    # @param get_instance [Proc] factory function for instance
    def initialize(id, get_instance)
      @id = id
      @get_instance = lambda do
        @instance = @instance || get_instance.call()
        @instance
      end
    end

    def method_missing(m, *args, &block)
      @get_instance.call().send(m, *args)
    end

    def [] (name)
      return @id if name == :id
      @get_instance.call()[name]
    end

  end
end
