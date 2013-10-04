module Bandwidth
  module API
    module AvailableNumbers

      def available_numbers
        numbers, _headers = get 'availableNumbers/local'

        numbers.map do |number|
          Types::LocalPhoneNumber.new number
        end
      end

      def available_toll_free_numbers
        numbers, _headers = get 'availableNumbers/tollFree'

        numbers.map do |number|
          Types::PhoneNumber.new number
        end
      end
    end
  end
end
