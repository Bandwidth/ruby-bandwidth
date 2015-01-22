module Bandwidth
  module Xml
    # Common functions of each verb class
    module XmlVerb
      def initialize(data = nil)
        @data = (data || {}).clone()
      end

      def method_missing(name, *args, &block)
        if name[name.size - 1] == '='
          @data[name[0..-2].to_sym] = args[0]
        else
          @data[name]
        end
      end

      def compact_hash(hash)
        hash.inject({}) do |new_hash, (k,v)|
          if !v.nil?
            new_hash[k] = v.class == Hash ? compact_hash(v) : v
          end
          new_hash
        end
      end
    end
  end
end
