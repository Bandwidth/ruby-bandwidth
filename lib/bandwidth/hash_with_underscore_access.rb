require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/string/inflections'

module Bandwidth
  class HashWithUnderscoreAccess < ActiveSupport::HashWithIndifferentAccess
    def method_missing name
      self[name]
    end

  protected
    def convert_key(key)
      super.underscore
    end
  end
end
