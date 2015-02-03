require 'uri'
module Bandwidth
  MEDIA_PATH = "media"
  # The Media resource lets you upload your media files to Bandwidth API servers
  class Media
    extend ClientWrapper

    # Get a list of your media files
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] query options
    # @return [Array] array with file information
    # @example
    #   files = Media.list(client)
    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(MEDIA_PATH), query)[0]
    end
    wrap_client_arg :list

    # Upload file to the Bandwidth API server
    # @param client [Client] optional client instance to make requests
    # @param name [String] file name
    # @param io [IO] io object file file content (file, string, etc)
    # @param media_type media type of file
    # @example
    #   Media.upload((client, "file.pdf", File.open("/path/to/file.pdf", "r"), "application/pdf")
    def self.upload(client, name, io, media_type = nil)
      connection = client.create_connection()
      # FIXME use streams directly when Faraday will be support streaming
      buf = io.read()
      response = connection.put("/#{client.api_version}#{client.concat_user_path(MEDIA_PATH)}/#{URI.encode(name)}") do |req|
        req.headers['Content-Length'] = buf.size.to_s
        req.headers['Content-Type'] = media_type || 'application/octet-stream'
        req.body = buf
      end
      client.check_response(response)
    end
    wrap_client_arg :upload

    # Download file from Bandwidth API server
    # @param client [Client] optional client instance to make requests
    # @param name [String] file name
    # @return [Array] file content and media type
    # @example
    #   file_content, media_type = Media.download(client, "file.pdf")
    def self.download(client, name)
      connection = client.create_connection()
      response = connection.get("/#{client.api_version}#{client.concat_user_path(MEDIA_PATH)}/#{URI.encode(name)}")
      [response.body, response.headers['Content-Type'] || 'application/octet-stream']
    end
    wrap_client_arg :download


    # Remove file from the Bandwidth API server
    # @param client [Client] optional client instance to make requests
    # @param name [String] file name
    # @example
    #   Media.delete(client, "file.pdf")
    def self.delete(client, name)
      client.make_request(:delete, client.concat_user_path("#{MEDIA_PATH}/#{URI.encode(name)}"))[0]
    end
    wrap_client_arg :delete
  end
end
