require 'active_support/core_ext/string/inflections'

module Bandwidth
  class HashCamelizer
    def initialize hash
      @hash = hash
    end

    def each
      @hash.each do |k, v|
        yield k.to_s.camelcase(:lower), v
      end
    end

    def method_missing name, *args, &block
      hash.send name, args, block
    end
  end
end
