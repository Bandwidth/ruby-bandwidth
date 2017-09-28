require 'timeout'

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
      #   message = Message.create(client, {:from=>"from", :to=>["to"], :text=>"text"})
      def self.create(client, data)
        client.make_request(:post, client.concat_user_path(MESSAGE_PATH), data, 'v2')[0]
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
      def self.create_messaging_application(auth_data, data, &configure_connection)
        app = {
          :application_id => self.create_application(auth_data, data, configure_connection),
          :location_id => self.create_location(auth_data, data, configure_connection)
        }
        self.enable_sms(auth_data, data[:sms_options], app, configure_connection)
        self.enable_mms(auth_data, data[:mms_options], app, configure_connection)
        self.assign_application_to_location(auth_data, app, configure_connection)
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
      def self.search_and_order_numbers(auth_data, application, query, &query_builder)
        builder = Builder::XmlMarkup.new()
        xml = builder.Order do |b|
          query_builder(b)
          b.SiteId(data[:name])
          b.PeerId(data[:callback_url])
        end
        resp = self.make_iris_request(auth_data, :post, "/orders", xml.target!)
        order_id = self.find_first_descendant(resp[0], "id")
        success_statuses = ["COMPLETE", "PARTIAL"]
        Timeout::timeout(query[:timeout] || 60) do
          while true do
            sleep 0.5
            resp = self.make_iris_request(auth_data, :get, "/orders/#{order_id}", nil, configure_connection)
            status = self.find_first_descendant(resp[0], "OrderStatus")
            return resp[0] if success_statuses.include?(status)
          end
        end
      end

      private def self.create_application(auth_data, data, &configure_connection)
        builder = Builder::XmlMarkup.new()
        xml = builder.Application do |b|
          b.AppName(data[:name])
          b.CallbackUrl(data[:callback_url])
          b.CallBackCreds do |bb|
            if data[:callback_auth_data] then
              bb.UserId(data[:callback_auth_data][:user_name])
              bb.Password(data[:callback_auth_data][:password])
            end
          end
        end
        resp = self.make_iris_request(auth_data, :post, "/applications", xml.target!, configure_connection)
        self.find_first_descendant(resp[0], "ApplicationId")
      end

      private def self.create_location(auth_data, data, &configure_connection)
        builder = Builder::XmlMarkup.new()
        xml = builder.SipPeer do |b|
          b.PeerName(data[:name])
          b.IsDefaultPeer(data[:callback_url])
        end
        resp = self.make_iris_request(auth_data, :post, "/sites/#{auth_data[:subaccount_id]}/sippeers", xml.target!, configure_connection)
        (resp[1]["Location"] || "").split!("/").last
      end

      private def self.enable_sms(auth_data, options, application, &configure_connection)
        return if !options || options[:enabled] == false
        builder = Builder::XmlMarkup.new()
        xml = builder.SipPeerSmsFeature do |b|
          b.SipPeerSmsFeatureSettings do |bb|
            bb.TollFree(options[:toll_free_enabled])
            bb.ShortCode(options[:short_code_enabled])
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
        self.make_iris_request(auth_data, :post, "/sites/#{auth_data[:subaccount_id]}/sippeers/#{application[:location_id]}/products/messaging/features/sms", xml.target!, configure_connection)
      end

      private def self.enable_mms(auth_data, options, application, &configure_connection)
        return if !options || options[:enabled] == false
        builder = Builder::XmlMarkup.new()
        xml = builder.MmsFeature do |b|
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
        self.make_iris_request(auth_data, :post, "/sites/#{auth_data[:subaccount_id]}/sippeers/#{application[:location_id]}/products/messaging/features/mms", xml.target!, configure_connection)
      end

      private def self.assign_application_to_location(auth_data, application, &configure_connection)
        builder = Builder::XmlMarkup.new()
        xml = builder.ApplicationsSettings do |b|
          b.HttpMessagingV2AppId(application[:application_id])
        end
        self.make_iris_request(auth_data, :put, "/sites/#{auth_data[:subaccount_id]}/sippeers/#{application[:location_id]}/products/messaging/applicationSettings", xml.target!, configure_connection)
      end

      private def self.create_iris_request(auth_data, method, &configure_connection)
        Faraday.new("https://dashboard.bandwidth.com") { |faraday|
          faraday.basic_auth(auth_data[:user_name], auth_data[:password])
          faraday.headers['Accept'] = 'application/xml'
          faraday.headers['User-Agent'] = "ruby-bandwidth/v#{Bandwidth::VERSION}"
          if configure_connection
            configure_connection.call(faraday)
          else
            faraday.adapter(Faraday.default_adapter)
          end
        }
      end

      private def self.make_iris_request(auth_data, method, path, xml = nil, &configure_connection)
        connection = self.create_iris_request(auth_data, method, path, configure_connection)
        full_path = "/api/accounts/#{auth_data[:account_id]}#{path}"
        response =  connection.run_request(method, full_path, xml, if xml then {'Content-Type' => 'application/xml'} else nil end)
        body = self.check_response(response)
        [body || {}, response.headers || {}]
      end

      private def self.check_response(response)
        parsed_body = self.parse_xml(response.body || '')
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
              raise Errors::AgregateError.new(errors.map {|e| Errors::GenericError.new(e[:code], e[:description], response.status)})
            end
          end
        end
        raise Errors::GenericError.new(code, description, response.status) if code && description && code != '0' && code != 0
        raise Errors::GenericError.new('', "Http code #{response.status}", response.status) if response.status >= 400
        parsed_body
      end

      private def self.find_first_descendant v, name
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

      private def self.parse_xml(xml)
        doc = ActiveSupport::XmlMini.parse(xml)
        self.process_parsed_doc(doc.values.first)
      end

      private def self.process_parsed_doc(v)
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
