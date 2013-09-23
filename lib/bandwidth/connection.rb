module Bandwidth
  class Connection
    def initialize user_id, token, secret
      @user_id, @token, @secret = user_id, token, secret
    end

    include AccountAPI

  protected
    def get path, parameters={}
      normalize_response connection.get url(path), camelcase(parameters)
    end

    def post path, parameters={}
      normalize_response connection.post url(path), camelcase(parameters)
    end

    def put path, parameters={}
      normalize_response connection.put url(path), camelcase(parameters)
    end

    def delete path, parameters={}
      normalize_response connection.delete url(path), camelcase(parameters)
    end

  private
    API_ENDPOINT = 'https://api.catapult.inetwork.com'
    API_VERSION = 'v1'

    def camelcase hash
      HashCamelizer.new hash
    end

    def url path
      [API_ENDPOINT, API_VERSION, 'users', @user_id, path].join '/'
    end

    def connection
      @connection ||= connect
    end

    def connect
      Faraday.new do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        # TODO: use something more advanced adapter when possible
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.basic_auth @token, @secret
      end
    end

    def normalize_response response
      # TODO: handle status codes
      # TODO: handle deep structures and provide ruby's underscore keys for hashes. be lazy
      parsed = JSON.parse response.body
    end
  end
end
