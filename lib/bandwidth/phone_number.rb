module Bandwidth
  PHONENUMBER_PATH = 'phoneNumbers'
  class PhoneNumber
    extend ClientWrapper
    include ApiItem

    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{PHONENUMBER_PATH}/#{id}"))[0]
      PhoneNumber.new(item, client)
    end
    wrap_client_arg :get

    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(PHONENUMBER_PATH), query)[0].map do |item|
        PhoneNumber.new(item, client)
      end
    end
    wrap_client_arg :list

    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(PHONENUMBER_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create

    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{PHONENUMBER_PATH}/#{id}"), data)[0]
    end

    def delete()
      @client.make_request(:delete, @client.concat_user_path("#{PHONENUMBER_PATH}/#{id}"))[0]
    end

    alias_method :destroy, :delete
  end
end
