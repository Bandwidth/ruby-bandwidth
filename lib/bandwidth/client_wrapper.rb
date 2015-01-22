module Bandwidth
  # Allows to make first argument (client instance) of defined singletom function optional
  module ClientWrapper
    # Make first argument (client instance) of a method optional
    #
    # @param method [Symbol] singleton method name
    # @example
    #   class MyClass
    #     extend ClientWrapper
    #
    #     def self.do_something(client, arg1, arg2)
    #     end
    #
    #     wrap_client_arg :do_something
    #     # Now you can make calls like MyClass.do_something(client, arg1, arg2) and MyClass.do_something(arg1, arg2)
    #     # In last case Client instance with default parameters (from Cleint.global_options) will be used
    #   end
    def wrap_client_arg(method)
      old = method(method)
      define_singleton_method(method) do |*args|
        if(args.size == 0 || !(args[0] || {}).is_a?(Client))
          args.unshift(Client.new())
        end
        old.call(*args)
      end
    end
  end
end
