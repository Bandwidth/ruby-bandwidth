require 'uri'
module Bandwidth
  MEDIA_PATH = "media"

  class Media
    extend ClientWrapper

    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(MEDIA_PATH), query)[0]
    end
    wrap_client_arg :list

    def self.upload(client, name, io, media_type = nil)
      connection = client.create_connection()
      # FIXME use streams directly when Faraday will be support streaming
      buf = io.read()
      response = connection.put("/#{client.api_version}#{client.concat_user_path(MEDIA_PATH)}/#{URI.encode(name)}") do |req|
        req.headers['Content-Length'] = buf.size
        req.headers['Content-Type'] = media_type || 'application/octet-stream'
        req.body = buf
      end
      client.check_response(response)
    end
    wrap_client_arg :upload


    def self.download(client, name)
      connection = client.create_connection()
      response = connection.get("/#{client.api_version}#{client.concat_user_path(MEDIA_PATH)}/#{URI.encode(name)}")
      [response.body, response.headers['Content-Type'] || 'application/octet-stream']
    end
    wrap_client_arg :download


    def self.delete(client, name)
      client.make_request(:delete, client.concat_user_path("#{MEDIA_PATH}/#{URI.encode(name)}"))[0]
    end
    wrap_client_arg :delete
  end
end
