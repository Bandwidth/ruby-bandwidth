module Bandwidth
  PHONENUMBER_PATH = 'phoneNumbers'
  # The Phone Numbers resource lets you get phone numbers for use with your programs and manage numbers you already have.
  class PhoneNumber
    extend ClientWrapper
    include ApiItem

    # Get information about one number
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of phone number
    # return [PhoneNumber] phone number information
    # @example
    #   number = PhoneNumber.get(client, "id")
    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{PHONENUMBER_PATH}/#{id}"))[0]
      PhoneNumber.new(item, client)
    end
    wrap_client_arg :get

    # Get a list of your numbers
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] query options
    # @return [Array] list of numbers
    # @example
    #   numbers = PhoneNumber.list(client)
    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(PHONENUMBER_PATH), query)[0].map do |item|
        PhoneNumber.new(item, client)
      end
    end
    wrap_client_arg :list

    # Allocate a number so you can use it
    # @param client [Client] optional client instance to make requests
    # @data [Hash]idata about new number
    # @return [PhoneNumber] created number information
    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(PHONENUMBER_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create

    # Make changes to a number you have
    # @param data [Hash] changed data
    # @example
    #   number.update(:name => "name")
    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{PHONENUMBER_PATH}/#{id}"), data)[0]
    end

    # Removes a number from your account
    # @example
    #   number.delete()
    def delete()
      @client.make_request(:delete, @client.concat_user_path("#{PHONENUMBER_PATH}/#{id}"))[0]
    end

    alias_method :destroy, :delete
  end
end
