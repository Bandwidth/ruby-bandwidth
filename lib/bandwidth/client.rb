require 'faraday'
require 'certified'
require 'json'
require 'active_support/core_ext/string/inflections'

module Bandwidth
  class Client
    def initialize (user_id = nil, api_token = nil, api_secret = nil, api_endpoint = 'https://api.catapult.inetwork.com', api_version = 'v1')
      if api_token == nil && api_secret == nil
        if  user_id == nil
          user_id = @@global_options
        end
        if user_id.is_a?(Hash)
          opts = user_id
          api_version = opts[:api_version] if opts[:api_version]
          api_endpoint = opts[:api_endpoint] if opts[:api_endpoint]
          api_secret = opts[:api_secret]
          api_token = opts[:api_token]
          user_id = opts[:user_id]
        end
      end
      @concat_user_path = lambda {|path| "/users/#{user_id}" + (if path[0] == "/" then path else "/#{path}" end) }
      @build_path = lambda {|path| "/#{api_version}" + (if path[0] == "/" then path else "/#{path}" end) }
      @set_adapter = lambda {|faraday| faraday.adapter(Faraday.default_adapter)}
      @create_connection = lambda{||
        Faraday.new(api_endpoint) { |faraday|
          faraday.basic_auth(api_token, api_secret)
          faraday.headers['Accept'] = 'application/json'
          @set_adapter.call(faraday)
        }
      }
    end

    @@global_options = {}

    def Client.global_options
      @@global_options
    end

    def Client.global_options=(v)
      @@global_options = v
    end

    def Client.get_id_from_location_header(location)
      items = (location || '').split('/')
      raise StandardError.new('Missing id in the location header') if items.size < 2
      items.last
    end

    def make_request(method, path, data = {})
      d  = camelcase(data)
      connection = @create_connection.call()
      response =  if method == :get || method == :delete
                    connection.run_request(method, @build_path.call(path), nil, nil) do |req|
                      req.params = d unless d == nil || d.empty?
                    end
                  else
                    connection.run_request(method, @build_path.call(path), d.to_json(), {'Content-Type' => 'application/json'})
                  end
      check_response(response)
      [if response.body.strip().size > 0 then symbolize(JSON.parse(response.body)) else {} end, symbolize(response.headers || {})]
    end

    def check_response(response)
      if response.status >= 400
        parsed_body = JSON.parse(response.body)
        raise Errors::GenericError.new(parsed_body['code'], parsed_body['message'])
      end
    end

    def concat_user_path(path)
      @concat_user_path.call(path)
    end

    protected

    def camelcase v
      case
        when v.is_a?(Array)
          v.map {|i| camelcase(i)}
        when v.is_a?(Hash)
          result = {}
          v.each do |k, val|
            result[k.to_s().camelcase(:lower)] = camelcase(val)
          end
          result
        else
          v
      end
    end

    def symbolize v
      case
        when v.is_a?(Array)
          v.map {|i| symbolize(i)}
        when v.is_a?(Hash)
          result = {}
          v.each do |k, val|
            result[k.underscore().to_sym()] = symbolize(val)
          end
          result
        else
          v
      end
    end
  end
end
