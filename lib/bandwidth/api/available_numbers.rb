module Bandwidth
  module API
    # The Available Numbers resource lets you search for numbers that are available for use with your application
    module AvailableNumbers

      # Searches for available local numbers by location or pattern criteria
      #
      # @param [Hash] options The options to search numbers with
      # @option options [String] :zip A 5-digit US ZIP code
      # @option options [String] :state A two-letter US state abbreviation ("CA" for California)
      # @option options [String] :area_code A 3-digit telephone area code (e.g. "919")
      # @option options [String] :city A city name
      # @option options [String] :pattern A number pattern that may include letters, digits, and the following wildcard characters: ? (matches any single digit), * (matches zero or more digits)
      #
      # @note zip, state and area_code options are mutually exclusive
      #
      # @return [Array<Types::LocalPhoneNumber>]
      #
      # @example
      #   bandwidth.available_numbers # => [#<LocalPhoneNumber:+19195551212>, #<LocalPhoneNumber:+13125556666>, ...]
      #
      # @example Filter by location
      #   bandwidth.available_numbers zip: '12345'
      #   bandwidth.available_numbers state: 'CA'
      #   bandwidth.available_numbers area_code: '919'
      #   bandwidth.available_numbers state: 'NC', city: 'Cary'
      #
      # @example Find using pattern
      #   bandwidth.available_numbers pattern: "*2?9*" # => [#<LocalPhoneNumber:+19192972393>, ...]@
      #
      def available_numbers options = {}
        raise ArgumentError, "ZIP code, state and area code are mutually exclusive" if (options.keys & MUTUALLY_EXCLUSIVE_OPTIONS).size > 1
        raise ArgumentError, "Unknown option passed: #{options.keys - OPTIONS}" if (options.keys - OPTIONS).size > 0

        LazyArray.new do |page, size|
          numbers, _headers = short_http.get 'availableNumbers/local', options.merge(page: page, size: size)

          numbers.map do |number|
            Types::LocalPhoneNumber.new number
          end
        end
      end

      # Searches for available Toll Free numbers
      #
      # @param [Hash] options The options to search numbers with
      # @option options [String] :pattern A number pattern that may include letters, digits, and the following wildcard characters: ? (matches any single digit), * (matches zero or more digits)
      #
      # @return [Array<Types::PhoneNumber>]
      #
      # @example
      #   bandwidth.available_toll_free_numbers # => [#<PhoneNumber:+19195551212>, #<PhoneNumber:+13125556666>, ...]
      #
      # @example Find using pattern
      #   bandwidth.available_toll_free_numbers pattern: "*2?9*" # => [#<PhoneNumber:+18557626967>, #<PhoneNumber:+18557712996>]
      #
      def available_toll_free_numbers options = {}
        raise ArgumentError, "Unknown option passed: #{options.keys - OPTIONS}" if (options.keys - OPTIONS).size > 0

        LazyArray.new do |page, size|
          numbers, _headers = short_http.get 'availableNumbers/tollFree', options.merge(page: page, size: size)

          numbers.map do |number|
            Types::PhoneNumber.new number
          end
        end
      end

    private
      OPTIONS = [:zip, :state, :area_code, :city, :pattern].freeze
      MUTUALLY_EXCLUSIVE_OPTIONS = [:zip, :state, :area_code].freeze
      TOLL_FREE_OPTIONS = [:pattern].freeze
    end
  end
end
