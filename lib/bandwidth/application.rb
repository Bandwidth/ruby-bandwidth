module Bandwidth
  APPLICATION_PATH = 'applications'
  class Application
    extend ClientWrapper
    include ApiItem

    def self.get(client,  id = nil)
      client.make_request(:get, client.concat_user_path("#{APPLICATION_PATH}/#{id}")).map do |item|
        Application.new(item, client)
      end
    end
    wrap_client_arg :get

    def self.list(client, query = nil)
      item = client.make_request(:get, client.concat_user_path(APPLICATION_PATH), query)
      Application.new(item, client)
    end
    wrap_client_arg :list

    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{APPLICATION_PATH}/#{id}"), data)
    end

    def delete()
      @client.make_request(:delete, @client.concat_user_path("#{APPLICATION_PATH}/#{id}"))
    end
  end
end
