module Bandwidth
  MESSAGE_PATH = 'messages'
  class Message
    extend ClientWrapper

    def self.get(client, id)
      client.make_request(:get, client.concat_user_path("#{MESSAGE_PATH}/#{id}"))[0]
    end
    wrap_client_arg :get

    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(MESSAGE_PATH), query)[0]
    end
    wrap_client_arg :list

    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(MESSAGE_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create
  end
end
