require_relative '../../../test_helper'

describe Bandwidth::API::Bridges do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "lists bridges" do
    @bandwidth.stub.get("/bridges") {[200, {}, <<-JSON
      [
        {
          "id": "brg-7cp5tvhydw4a3esxwpww5qa",
          "state": "completed",
          "bridgeAudio": true,
          "calls":"https://.../v1/users/{userId}/bridges/{bridgeId}/calls",
          "createdTime": "2013-04-22T13:55:30.279Z",
          "activatedTime": "2013-04-22T13:55:30.280Z",
          "completedTime": "2013-04-22T13:56:30.122Z"
        },
        {
          "id": "brg-hyde7cpvsxwpw5qa4a35twe",
          "state": "completed",
          "bridgeAudio": true,
          "calls":"https://.../v1/users/u-docj4znxesdut4sj4guecea/bridges/brg-hyde7cpvsxwpw5qa4a35twe/calls",
          "createdTime": "2013-04-22T13:58:30.121Z",
          "activatedTime": "2013-04-22T13:58:30.122Z",
          "completedTime": "2013-04-22T13:59:30.122Z"
        }
      ]
      JSON
    ]}

    bridges = @bandwidth.bridges
    assert_equal 2, bridges.size

    bridge = bridges.first
    assert_equal "brg-7cp5tvhydw4a3esxwpww5qa", bridge.id
    assert_equal "completed", bridge.state
    assert_equal true, bridge.bridge_audio
    assert_equal Time.parse("2013-04-22T13:55:30.279Z"), bridge.created_time
    assert_equal Time.parse("2013-04-22T13:55:30.280Z"), bridge.activated_time
    assert_equal Time.parse("2013-04-22T13:56:30.122Z"), bridge.completed_time
  end

  it "bridges two calls" do
    call_id1 = "c-mxdxhidpjr6a2bp2lxq6vaa"
    call_id2 = "c-c2rui2kbrldsfgjhlvlnjaq"

    @bandwidth.stub.post("/bridges") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal call_id1, parsed_body['callIds'][0]
      assert_equal call_id2, parsed_body['callIds'][1]

      [200, {}, "{}"]
    end

    @bandwidth.bridge call_id1, call_id2
  end

  it "respects bridge audio option when bridging calls" do
    call_id1 = "c-mxdxhidpjr6a2bp2lxq6vaa"
    call_id2 = "c-c2rui2kbrldsfgjhlvlnjaq"

    @bandwidth.stub.post("/bridges") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal false, parsed_body['bridgeAudio']

      [200, {}, "{}"]
    end

    @bandwidth.bridge call_id1, call_id2, false
  end

  it "gets information on specified bridge" do
    bridge_id = "brg-7cp5tvhydw4a3esxwpww5qa"

    @bandwidth.stub.get("/bridges/#{bridge_id}") {[200, {}, <<-JSON
      {
        "id": "#{bridge_id}",
        "state": "completed",
        "bridgeAudio": true,
        "calls":"https://.../v1/users/{userId}/bridges/{bridgeId/calls",
        "createdTime": "2013-04-22T13:55:30.279Z",
        "activatedTime": "2013-04-22T13:55:30.280Z",
        "completedTime": "2013-04-22T13:59:30.122Z"
      }
      JSON
    ]}

    bridge = @bandwidth.bridge_info bridge_id
    assert_equal bridge_id, bridge.id
    assert_equal "completed", bridge.state
    assert_equal true, bridge.bridge_audio
    assert_equal Time.parse("2013-04-22T13:55:30.279Z"), bridge.created_time
    assert_equal Time.parse("2013-04-22T13:55:30.280Z"), bridge.activated_time
    assert_equal Time.parse("2013-04-22T13:59:30.122Z"), bridge.completed_time
  end

  it "sets audio bridging" do
    bridge_id = "brg-7cp5tvhydw4a3esxwpww5qa"

    @bandwidth.stub.post("/bridges/#{bridge_id}") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal false, parsed_body['bridgeAudio']

      [200, {}, "{}"]
    end

    @bandwidth.bridge_audio bridge_id, false
  end

  it "plays media" do
    bridge_id = "brg-7cp5tvhydw4a3esxwpww5qa"
    audio_url = "http://example.com/audio.mp3"
    audio = Bandwidth::Audio::File.new audio_url

    @bandwidth.stub.post("/bridges/#{bridge_id}/audio") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal audio_url, parsed_body['fileUrl']

      [200, {}, ""]
    end

    @bandwidth.bridge_play bridge_id, audio
  end

  it "destroys a bridge" do
    bridge_id = "brg-7cp5tvhydw4a3esxwpww5qa"

    @bandwidth.stub.post("/bridges/#{bridge_id}") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal [], parsed_body['callIds']

      [200, {}, "{}"]
    end

    @bandwidth.unbridge bridge_id
  end

  it "lists the calls that are bridged together" do
    bridge_id = "brg-775ey3y6dwc2zoyrfgn36ai"

    @bandwidth.stub.get("/bridges/#{bridge_id}/calls") {[200, {}, <<-JSON
      [
        {
          "activeTime": "2013-05-22T19:49:39Z",
          "direction": "out",
          "from": "+17195551001",
          "id": "c-ps5yx4tlfwygia67bb5eufq",
          "bridgeId": "brg-775ey3y6dwc2zoyrfgn36ai",
          "startTime": "2013-05-22T19:49:35Z",
          "state": "active",
          "to": "+15755551002",
          "recordingEnabled": false,
          "events": "https://api.catapult.inetwork.com/v1/users/.../calls/c-ps5yx4tlfwygia67bb5eufq/events",
          "bridge": "https://api.catapult.inetwork.com/v1/users/.../bridges/brg-775ey3y6dwc2zoyrfgn36ai"
        },
        {
          "activeTime": "2013-05-22T19:50:16Z",
          "direction": "out",
          "from": "+17195551001",
          "id": "c-r4ptwoqimxo3g66yktvmxfa",
          "bridgeId": "brg-775ey3y6dwc2zoyrfgn36ai",
          "startTime": "2013-05-22T19:50:16Z",
          "state": "active",
          "to": "+19205551003",
          "recordingEnabled": false,
          "events": "https://api.catapult.inetwork.com/v1/users/.../calls/c-r4ptwoqimxo3g66yktvmxfa/events",
          "bridge": "https://api.catapult.inetwork.com/v1/users/.../bridges/brg-775ey3y6dwc2zoyrfgn36ai"
        }
      ]
      JSON
    ]}

    calls = @bandwidth.bridged_calls bridge_id
    assert_equal 2, calls.size

    call = calls.first
    assert_equal "c-ps5yx4tlfwygia67bb5eufq", call.id
    assert_equal "out", call.direction
    assert_equal "+17195551001", call.from
    assert_equal "+15755551002", call.to
    assert_equal "active", call.state
    assert_equal Time.parse("2013-05-22T19:49:39Z"), call.active_time
    assert_equal Time.parse("2013-05-22T19:49:35Z"), call.start_time
    assert_equal bridge_id, call.bridge_id
    assert_equal false, call.recording_enabled
  end
end
