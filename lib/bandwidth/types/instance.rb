require 'active_support/core_ext/string/inflections'
require 'time'

module Bandwidth
  module Types
    module Instance
      # @api private
      def self.included base
        base.extend ClassMethods
        base.instance_variable_set :@attributes, {}
      end

      # @api private
      def initialize parsed_json
        attributes = self.class.instance_variable_get :@attributes
        attributes.each do |attribute, coercion|
          value = parsed_json[attribute.to_s.camelcase(:lower)]
          coerced = coerce value, coercion

          define_singleton_method attribute do
            coerced
          end
        end
      end

    protected
      def coerce value, coercion
        if coercion == nil
          value
        elsif coercion == Float
          value.to_f
        elsif coercion == Integer
          value.to_i
        elsif coercion == Time
          Time.parse value
        end
      end

      # @api private
      module ClassMethods
        def attribute name, coercion = nil
          @attributes[name] = coercion
        end

        def inherited base
          attributes = self.instance_variable_get :@attributes
          base.instance_variable_set :@attributes, attributes
        end
      end
    end
  end
end
