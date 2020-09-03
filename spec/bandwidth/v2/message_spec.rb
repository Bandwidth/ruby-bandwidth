describe Bandwidth::V2::Message do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#create' do
    it 'should create new item' do
      client.stubs.post('/api/v2/users/userId/messages', '{"text":"hello"}') {|env| [202, {}, '{"id": "messageId"}']}
      expect(V2::Message.create(client, {:text=>'hello'})).to eql({id: 'messageId'})
    end
  end

  describe '#create_iris_request' do
    it 'should create Faraday instance for Bandwidth dashboard' do
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      connection = V2::Message.send(:create_iris_request, {user_name: 'user', password: 'password'})
      expect(connection.headers["Authorization"]).to eql("Basic dXNlcjpwYXNzd29yZA==")
      expect(connection.headers["Accept"]).to eql("application/xml")
    end
  end

  describe '#make_iris_request' do
    it 'should make  http request to dashboard' do
      client.stubs.get('/api/accounts/accountId/test') {|env| [200, {}, '<Response>test</Response>']}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      r = V2::Message.send(:make_iris_request, {user_name: 'user', password: 'password', account_id: 'accountId'}, :get, '/test')
      expect(r[0]).to eql("test")
    end
  end

  describe '#check_response' do
    it 'should check errors 1' do
      client.stubs.get('/api/accounts/accountId/test') {|env| [404, {}, '']}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      expect{V2::Message.send(:make_iris_request, {user_name: 'user', password: 'password', account_id: 'accountId'}, :get, '/test')}.to raise_error(Errors::GenericIrisError)
    end
  end

  describe '#create_application' do
    it 'should make create a messaging application' do
      client.stubs.post('/api/accounts/accountId/applications', '<Application><AppName>Test</AppName><CallbackUrl>url</CallbackUrl><CallBackCreds></CallBackCreds></Application>') {|env| [200, {}, '<ApplicationProvisioningResponse><Application><ApplicationId>id</ApplicationId></Application></ApplicationProvisioningResponse>']}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      id = V2::Message.send(:create_application, {user_name: 'user', password: 'password', account_id: 'accountId'}, {name: 'Test', callback_url: 'url'})
      expect(id).to eql("id")
    end
  end

  describe '#create_location' do
    it 'should make create a location' do
      client.stubs.post('/api/accounts/accountId/sites/subaccountId/sippeers', '<SipPeer><PeerName>current</PeerName><IsDefaultPeer>false</IsDefaultPeer></SipPeer>') {|env| [201, {'Location' => 'httpl//localhoost/id'}, '']}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      id = V2::Message.send(:create_location, {user_name: 'user', password: 'password', account_id: 'accountId', subaccount_id: 'subaccountId'}, {location_name: 'current', is_default_location: false})
      expect(id).to eql("id")
    end
  end

  describe '#enable_sms' do
    it 'should change sms settings' do
      client.stubs.post('/api/accounts/accountId/sites/subaccountId/sippeers/locationId/products/messaging/features/sms', '<SipPeerSmsFeature><SipPeerSmsFeatureSettings><TollFree>true</TollFree><ShortCode>false</ShortCode><Protocol>HTTP</Protocol><Zone1>true</Zone1><Zone2>false</Zone2><Zone3>false</Zone3><Zone4>false</Zone4><Zone5>false</Zone5></SipPeerSmsFeatureSettings><HttpSettings><ProxyPeerId></ProxyPeerId></HttpSettings></SipPeerSmsFeature>') {|env| [201, {}, '']}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      V2::Message.send(:enable_sms, {user_name: 'user', password: 'password', account_id: 'accountId', subaccount_id: 'subaccountId'}, {toll_free_enabled: true}, {application_id: 'appId', location_id: 'locationId'})
    end
    it 'should do nothing when enabled=false' do
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      V2::Message.send(:enable_sms, {user_name: 'user', password: 'password', account_id: 'accountId', subaccount_id: 'subaccountId'}, {enabled: false}, {application_id: 'appId', location_id: 'locationId'})
    end
  end

  describe '#enable_mms' do
    it 'should change mms settings' do
      client.stubs.post('/api/accounts/accountId/sites/subaccountId/sippeers/locationId/products/messaging/features/mms', '<MmsFeature><MmsSettings><Protocol>HTTP</Protocol></MmsSettings><Protocols><HTTP><HttpSettings><ProxyPeerId></ProxyPeerId></HttpSettings></HTTP></Protocols></MmsFeature>') {|env| [201, {}, '']}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      V2::Message.send(:enable_mms, {user_name: 'user', password: 'password', account_id: 'accountId', subaccount_id: 'subaccountId'}, {enabled: true}, {application_id: 'appId', location_id: 'locationId'})
    end
    it 'should do nothing when enabled=false' do
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      V2::Message.send(:enable_mms, {user_name: 'user', password: 'password', account_id: 'accountId', subaccount_id: 'subaccountId'}, {enabled: false}, {application_id: 'appId', location_id: 'locationId'})
    end
  end

  describe '#assign_application_to_location' do
    it 'should assign application to location' do
      client.stubs.put('/api/accounts/accountId/sites/subaccountId/sippeers/locationId/products/messaging/applicationSettings', '<ApplicationsSettings><HttpMessagingV2AppId>appId</HttpMessagingV2AppId></ApplicationsSettings>') {|env| [200, {}, '']}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      V2::Message.send(:assign_application_to_location, {user_name: 'user', password: 'password', account_id: 'accountId', subaccount_id: 'subaccountId'}, {application_id: 'appId', location_id: 'locationId'})
    end
  end

  describe '#create_messaging_application' do
    it 'should make create a messaging application and location' do
      client.stubs.post('/api/accounts/accountId/applications', '<Application><AppName>Test</AppName><CallbackUrl>url</CallbackUrl><CallBackCreds></CallBackCreds></Application>') {|env| [200, {}, '<ApplicationProvisioningResponse><Application><ApplicationId>id</ApplicationId></Application></ApplicationProvisioningResponse>']}
      client.stubs.post('/api/accounts/accountId/sites/subaccountId/sippeers', '<SipPeer><PeerName>current</PeerName><IsDefaultPeer>false</IsDefaultPeer></SipPeer>') {|env| [201, {'Location' => 'httpl//localhoost/locationId'}, '']}
      client.stubs.post('/api/accounts/accountId/sites/subaccountId/sippeers/locationId/products/messaging/features/sms', '<SipPeerSmsFeature><SipPeerSmsFeatureSettings><TollFree>true</TollFree><ShortCode>false</ShortCode><Protocol>HTTP</Protocol><Zone1>true</Zone1><Zone2>false</Zone2><Zone3>false</Zone3><Zone4>false</Zone4><Zone5>false</Zone5></SipPeerSmsFeatureSettings><HttpSettings><ProxyPeerId></ProxyPeerId></HttpSettings></SipPeerSmsFeature>') {|env| [201, {}, '']}
      client.stubs.post('/api/accounts/accountId/sites/subaccountId/sippeers/locationId/products/messaging/features/mms', '<MmsFeature><MmsSettings><Protocol>HTTP</Protocol></MmsSettings><Protocols><HTTP><HttpSettings><ProxyPeerId></ProxyPeerId></HttpSettings></HTTP></Protocols></MmsFeature>') {|env| [201, {}, '']}
      client.stubs.put('/api/accounts/accountId/sites/subaccountId/sippeers/locationId/products/messaging/applicationSettings', '<ApplicationsSettings><HttpMessagingV2AppId>id</HttpMessagingV2AppId></ApplicationsSettings>') {|env| [200, {}, '']}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      app = V2::Message.create_messaging_application({user_name: 'user', password: 'password', account_id: 'accountId', subaccount_id: 'subaccountId'}, {name: 'Test', callback_url: 'url', location_name: 'current', is_default_location: false, sms_options: {toll_free_enabled: true}, mms_options: {enabled: true}})
      expect(app[:application_id]).to eql("id")
      expect(app[:location_id]).to eql("locationId")
    end
  end

  describe '#search_and_order_numbers' do
    it 'should search and order numbers' do
      order_response = '<OrderResponse><CompletedQuantity>1</CompletedQuantity><CreatedByUser>lorem</CreatedByUser><LastModifiedDate>2017-09-18T17:36:57.411Z</LastModifiedDate><OrderCompleteDate>2017-09-18T17:36:57.410Z</OrderCompleteDate><Order><OrderCreateDate>2017-09-18T17:36:57.274Z</OrderCreateDate><PeerId>{{location}}</PeerId><BackOrderRequested>false</BackOrderRequested><AreaCodeSearchAndOrderType><AreaCode>910</AreaCode><Quantity>2</Quantity></AreaCodeSearchAndOrderType><PartialAllowed>true</PartialAllowed><SiteId>{{subaccount}}</SiteId></Order><OrderStatus>COMPLETE</OrderStatus><CompletedNumbers><TelephoneNumber><FullNumber>9102398766</FullNumber></TelephoneNumber><TelephoneNumber><FullNumber>9102398767</FullNumber></TelephoneNumber></CompletedNumbers><Summary>1 number ordered in (910)</Summary><FailedQuantity>0</FailedQuantity></OrderResponse>'
      client.stubs.post('/api/accounts/accountId/orders', '<Order><AreaCodeSearchAndOrderType><AreaCode>910</AreaCode><Quantity>2</Quantity></AreaCodeSearchAndOrderType><SiteId>subaccountId</SiteId><PeerId>locationId</PeerId></Order>') {|env| [200, {}, '<OrderResponse><Order><OrderCreateDate>2017-09-18T17:36:57.274Z</OrderCreateDate><PeerId>{{location}}</PeerId><BackOrderRequested>false</BackOrderRequested><id>orderId</id><AreaCodeSearchAndOrderType><AreaCode>910</AreaCode><Quantity>1</Quantity></AreaCodeSearchAndOrderType><PartialAllowed>true</PartialAllowed><SiteId>{{subaccount}}</SiteId></Order><OrderStatus>RECEIVED</OrderStatus></OrderResponse>']}
      client.stubs.get('/api/accounts/accountId/orders/orderId'){|env| [200, {}, order_response]}
      V2::Message.send(:configure_connection, lambda {|faraday| faraday.adapter(:test, client.stubs)})
      numbers = V2::Message.search_and_order_numbers({user_name: 'user', password: 'password', account_id: 'accountId', subaccount_id: 'subaccountId'}, {application_id: 'id', location_id: 'locationId'}) do |query|
        query.AreaCodeSearchAndOrderType do |b|
          b.AreaCode("910")
          b.Quantity(2)
        end
      end
      expect(numbers.size).to eql(2)
    end
  end
end
