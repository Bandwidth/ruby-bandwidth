module Bandwidth
  module ClientWrapper
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
