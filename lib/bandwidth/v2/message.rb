require 'timeout'
require 'active_support/xml_mini'

module Bandwidth
  module V2
    MESSAGE_PATH = 'messages'
    # The Messages resource lets you send SMS text messages and view messages that were previously sent or received.
    class Message
      extend ClientWrapper
      # Send text messages
      # @param client [Client] optional client instance to make requests
      # @param data [Hash] options of new message or list of messages
      # @return [Hash] created message or statuses of list of messages
      # @example
      #   message = Message.create(client, {:from=>"from", :to=>["to"], :text=>"text", :application_id=>"messagingApplicationId"})
      def self.create(client, data)
        client.make_request(:post, client.concat_user_path(MESSAGE_PATH), data, 'api/v2', 'https://messaging.bandwidth.com')[0]
      end
      wrap_client_arg :create

      # Create messaging application
      # @param auth_data [Hash] bandwidth dashboard auth data
      # @param data [Hash] options to create a messaging application
      # @return [Hash] created application data
      # @example
      #   application = Message.create_messaging_application(auth_data, {
      #     name: 'My messaging application',
      #     callback_url: 'http://server/to/handle/messages/events',
      #     location_name: 'current',
      #     sms_options: {toll_free_enabled: true},
      #     mms_options: {enabled: true}
      #   })
      def self.create_messaging_application(auth_data, data)
        app = {
          :application_id => self.create_application(auth_data, data),
          :location_id => self.create_location(auth_data, data)
        }
        self.enable_sms(auth_data, data[:sms_options], app)
        self.enable_mms(auth_data, data[:mms_options], app)
        self.assign_application_to_location(auth_data, app)
        app
      end

      # Look for and reserve phone numbers for messaging application
      # @param auth_data [Hash] bandwidth dashboard auth data
      # @param application [Hash] messaging application data
      # @param query [Hash] search parameters
      # @return [Array] list of reserved phone numbers
      # @example
      #   numbers = Message.search_and_order_numbers(auth_data, application) do |query|
      #     query.AreaCodeSearchAndOrderType do |b|
      #         b.AreaCode("910")
      #         b.Quantity(10)
      #     end
      #   end
      def self.search_and_order_numbers(auth_data, application, timeout = 60, &query_builder)
        builder = Builder::XmlMarkup.new()
        builder.Order do |b|
          query_builder.call(b) if query_builder
          b.SiteId(auth_data[:subaccount_id])
          b.PeerId(application[:location_id])
        end
        resp = self.make_iris_request(auth_data, :post, "/orders", builder.target!)
        order_id = self.find_first_descendant(resp[0], :id)
        success_statuses = ["COMPLETE", "PARTIAL"]
        Timeout::timeout(timeout || 60) do
          while true do
            sleep 0.5
            resp = self.make_iris_request(auth_data, :get, "/orders/#{order_id}")
            status = self.find_first_descendant(resp[0], :order_status)
            numbers = self.find_first_descendant(resp[0], :completed_numbers)[:telephone_number]
            numbers = [numbers] unless numbers.is_a?(Array)
            return numbers.map {|n| n[:full_number]} if success_statuses.include?(status)
          end
        end
      end

      private
      def self.create_application(auth_data, data)
        builder = Builder::XmlMarkup.new()
        builder.Application do |b|
          b.AppName(data[:name])
          b.CallbackUrl(data[:callback_url])
          b.CallBackCreds do |bb|
            if data[:callback_auth_data] then
              bb.UserId(data[:callback_auth_data][:user_name])
              bb.Password(data[:callback_auth_data][:password])
            end
          end
        end
        resp = self.make_iris_request(auth_data, :post, "/applications", builder.target!)
        self.find_first_descendant(resp[0], :application_id)
      end

      def self.create_location(auth_data, data)
        builder = Builder::XmlMarkup.new()
        builder.SipPeer do |b|
          b.PeerName(data[:location_name])
          b.IsDefaultPeer(data[:is_default_location])
        end
        resp = self.make_iris_request(auth_data, :post, "/sites/#{auth_data[:subaccount_id]}/sippeers", builder.target!)
        (resp[1]["Location"] || "").split("/").last
      end

      def self.enable_sms(auth_data, options, application)
        return if !options || options[:enabled] == false
        builder = Builder::XmlMarkup.new()
        builder.SipPeerSmsFeature do |b|
          b.SipPeerSmsFeatureSettings do |bb|
            bb.TollFree(options[:toll_free_enabled] || false)
            bb.ShortCode(options[:short_code_enabled] || false)
            bb.Protocol("HTTP")
            bb.Zone1(true)
            bb.Zone2(false)
            bb.Zone3(false)
            bb.Zone4(false)
            bb.Zone5(false)
          end
          b.HttpSettings do |bb|
            bb.ProxyPeerId("539692")
          end
        end
        self.make_iris_request(auth_data, :post, "/sites/#{auth_data[:subaccount_id]}/sippeers/#{application[:location_id]}/products/messaging/features/sms", builder.target!)
      end

      def self.enable_mms(auth_data, options, application)
        return if !options || options[:enabled] == false
        builder = Builder::XmlMarkup.new()
        builder.MmsFeature do |b|
          b.MmsSettings do |bb|
            bb.protocol("HTTP")
          end
          b.Protocols do |bb|
            bb.HTTP do |bbb|
              bbb.HttpSettings do |bbbb|
                bbbb.ProxyPeerId("539692")
              end
            end
          end
        end
        self.make_iris_request(auth_data, :post, "/sites/#{auth_data[:subaccount_id]}/sippeers/#{application[:location_id]}/products/messaging/features/mms", builder.target!)
      end

      def self.assign_application_to_location(auth_data, application)
        builder = Builder::XmlMarkup.new()
        builder.ApplicationsSettings do |b|
          b.HttpMessagingV2AppId(application[:application_id])
        end
        self.make_iris_request(auth_data, :put, "/sites/#{auth_data[:subaccount_id]}/sippeers/#{application[:location_id]}/products/messaging/applicationSettings", builder.target!)
      end

      def self.create_iris_request(auth_data)
        Faraday.new("https://dashboard.bandwidth.com") { |faraday|
          faraday.basic_auth(auth_data[:user_name], auth_data[:password])
          faraday.headers['Accept'] = 'application/xml'
          faraday.headers['User-Agent'] = "ruby-bandwidth/v#{Bandwidth::VERSION}"
          if @@configure_connection
            @@configure_connection.call(faraday)
          else
            faraday.adapter(Faraday.default_adapter)
          end
        }
      end

      def self.configure_connection(handler)
        @@configure_connection = handler
      end

      def self.make_iris_request(auth_data, method, path, xml = nil)
        connection = self.create_iris_request(auth_data)
        full_path = "/api/accounts/#{auth_data[:account_id]}#{path}"
        response =  connection.run_request(method, full_path, xml, if xml then {'Content-Type' => 'application/xml'} else nil end)
        body = self.check_response(response)
        [body || {}, response.headers || {}]
      end

      def self.check_response(response)
        doc = ActiveSupport::XmlMini.parse(response.body || '')
        parsed_body = self.process_parsed_doc(doc.values.first)
        code = self.find_first_descendant(parsed_body, :error_code)
        description = self.find_first_descendant(parsed_body, :description)
        unless code
          error = self.find_first_descendant(parsed_body, :error)
          if error
            code = error[:code]
            description = error[:description]
          else
            errors = self.find_first_descendant(parsed_body, :errors)
            if errors == nil || errors.length == 0
              code = self.find_first_descendant(parsed_body, :result_code)
              description = self.find_first_descendant(parsed_body, :result_message)
            else
              errors = [errors] if errors.is_a?(Hash)
              raise Errors::AgregateError.new(errors.map {|e| Errors::GenericIrisError.new(e[:code], e[:description], response.status)})
            end
          end
        end
        raise Errors::GenericIrisError.new(code, description, response.status) if code && description && code != '0' && code != 0
        raise Errors::GenericIrisError.new('', "Http code #{response.status}", response.status) if response.status >= 400
        parsed_body
      end

      def self.find_first_descendant v, name
        result = nil
        case
          when v.is_a?(Array)
            v.each do |val|
              result = self.find_first_descendant(val, name)
              break if result
            end
          when v.is_a?(Hash)
            v.each do |k, val|
              if k == name
                result = val
                break
              else
                result = self.find_first_descendant(val, name)
                break if result
              end
            end
        end
        result
      end

      def self.process_parsed_doc(v)
        case
          when v.is_a?(Array)
            v.map {|i| self.process_parsed_doc(i)}
          when v.is_a?(Hash)
            return self.process_parsed_doc(v['__content__']) if v.keys.length == 1 && v['__content__']
            result = {}
            v.each do |k, val|
              key =  if k.downcase() == 'lata' then :lata else k.underscore().to_sym() end
              result[key] = self.process_parsed_doc(val)
            end
            result
          when v == "true" || v == "false"
            v == "true"
          when /^\d{4}\-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}(\.\d{3})?Z$/.match(v)
            DateTime.iso8601(v)
          when /\A\d{9}\d?\Z/.match(v)
            v
          when /\A[1-9]\d*\Z/.match(v)
            Integer(v)
          when /\A[-+]?[0-9]*\.?[0-9]+\Z/.match(v)
            Float(v)
          else
            v
        end
      end
    end
  end
end
