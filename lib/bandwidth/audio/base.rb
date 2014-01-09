module Bandwidth
  module Audio
    # @api private
    class Base

    protected
      def to_hash
        hash = {}
        hash.merge!({loop_enabled: @options[:loop_enabled]}) unless @options[:loop_enabled].nil?
        hash.merge!({bargeable: @options[:bargeable]}) unless @options[:bargeable].nil?
        hash
      end
    end
  end
end

