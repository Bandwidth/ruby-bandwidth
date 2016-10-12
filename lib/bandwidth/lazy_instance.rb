module Bandwidth
  class LazyInstance
    attr_reader :id

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
