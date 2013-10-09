module Bandwidth
  module API
    module PhoneNumbers

      # Get a list of your numbers
      #
      # @return [Array<Types::AllocatedPhoneNumber>]
      #
      # @example Get a list of allocated numbers
      #   numbers = bandwidth.phone_numbers # => [#<AllocatedPhoneNumber:+19195551212>, #<AllocatedPhoneNumber:+13125556666>, ...]
      #
      #   number = numbers.first
      #
      #   number.id # => "n-6nuymbplrb3zd5yazve2ley"
      #   number.number # => "+19195551212"
      #   number.national_number # => "(919) 555-1212"
      #   number.name # => "home phone"
      #   number.state # => "NC"
      #
      def phone_numbers
        phone_numbers, _headers = get 'phoneNumbers'

        phone_numbers.map do |phone_number|
          Types::AllocatedPhoneNumber.new phone_number
        end
      end

      # Allocate a number so you can use it
      #
      # @param [String] phone_number Phone number to allocate
      # @param [String, nil] name Custom phone number name
      #
      # @return [String] Phone number identifier
      #
      # @example
      #   number_id = bandwidth.allocate_number "+19195551212"
      #
      def allocate_number phone_number, name=nil
        options = {number: phone_number}
        options.merge!(name: name) if name
        _body, headers = post 'phoneNumbers', options
        headers['location'].match(/[^\/]+$/)[0]
      end

      # Get information about allocated phone number
      #
      # @return [Types::AllocatedPhoneNumber]
      #
      # @example
      #   bandwidth.phone_number_details # => #<AllocatedPhoneNumber:+19195551212>
      #
      def phone_number_details phone_number_or_id
        phone_number, _headers = get "phoneNumbers/#{phone_number_or_id}"

        Types::AllocatedPhoneNumber.new phone_number
      end

      # Remove a number from your account
      #
      # @param [String] phone_number_id Phone number or identifier
      #
      # @example
      #   bandwidth.remove_number "n-6nuymbplrb3zd5yazve2ley"
      #
      def remove_number phone_number_id
        _body, _headers = delete "phoneNumbers/#{phone_number_id}"
        nil
      end
    end
  end
end
