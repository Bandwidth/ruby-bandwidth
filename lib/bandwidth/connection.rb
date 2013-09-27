require 'faraday'
require 'json'

module Bandwidth
  class Connection

    # (see Bandwidth.new)
    def initialize user_id, token, secret
      @user_id, @token, @secret = user_id, token, secret
    end

    include API::Account
    include API::Messages

  protected
    def get path, parameters={}
      normalize_response connection.get url(path), camelcase(parameters)
    end

    def post path, parameters={}
      response = connection.post do |req|
        req.url url path
        req.headers['Content-Type'] = 'application/json'
        req.body = camelcase(parameters).to_json
      end

      normalize_response response
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
        # TODO: use more advanced adapter when possible
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.basic_auth @token, @secret
      end
    end

    def normalize_response response
      # TODO: handle deep structures and provide ruby's underscore keys for hashes. be lazy
      parsed_body = JSON.parse response.body if response.body.size > 1

      if response.status >= 400
        if parsed_body['code'] == 'restricted-number'
          fail Errors::RestrictedNumber.new parsed_body['message']
        else
          fail Errors::GenericError.new parsed_body['code'], parsed_body['message']
        end
      end

      return parsed_body, response.headers
    end

    # @api private
    class HashCamelizer
      def initialize hash
        @hash = hash
      end

      def each
        @hash.each do |k, v|
          yield k.to_s.camelcase(:lower), v
        end
      end
    end
  end
end
