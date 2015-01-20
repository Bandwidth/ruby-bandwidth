module Bandwidth
  BRIDGE_PATH = 'bridges'
  class Bridge
    extend ClientWrapper
    include ApiItem

    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{BRIDGE_PATH}/#{id}"))[0]
      Bridge.new(item, client)
    end
    wrap_client_arg :get

    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(BRIDGE_PATH), query)[0].map do |item|
        Bridge.new(item, client)
      end
    end
    wrap_client_arg :list

    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(BRIDGE_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create

    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{BRIDGE_PATH}/#{id}"), data)[0]
    end

    def play_audio(data)
      @client.make_request(:post, @client.concat_user_path("#{BRIDGE_PATH}/#{id}/audio"), data)[0]
    end

    def get_calls()
      @client.make_request(:get, @client.concat_user_path("#{BRIDGE_PATH}/#{id}/calls"))[0].map do |item|
        Call.new(item, @client)
      end
    end
  end
end
