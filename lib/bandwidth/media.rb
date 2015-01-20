require 'uri'
module Bandwidth
  MEDIA_PATH = "media"

  class Media
    extend ClientWrapper

    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(MEDIA_PATH), query)
    end
    wrap_client_arg :list

    def self.upload(client, name, io, media_type = nil)
      connection = client.create_connection()
      buf = io.read()
      response = connection.put do |req|
        req.url = "/#{client.api_version}/#{MEDIA_PATH}/#{URI.encode(name)}"
        req.headers['Content-Length'] = buf.size
        req.headers['Content-Type'] = media_type || 'application/octet-stream'
        req.body = buf
      end
      check_response(response)
    end
    wrap_client_arg :upload


    def self.download(client, name, destination)
    end
    wrap_client_arg :download


    def self.delete(client, name)
      client.make_request(:delete, client.concat_user_path("#{MEDIA_PATH}/#{URI.encode(name)}"))
    end
    wrap_client_arg :delete
  end
end
