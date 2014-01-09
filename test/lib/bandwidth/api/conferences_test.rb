require_relative '../../../test_helper'

describe Bandwidth::API::Conferences do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "creates a conference" do
    from = "+19205551003"
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"

    @bandwidth.stub.post("conferences") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal from, parsed_body['from']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/conferences/#{conference_id}"}, ""]
    end

    assert_equal conference_id, @bandwidth.conference(from)
  end

  it "retrieves conference information" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"

    @bandwidth.stub.get("/conferences/#{conference_id}") {[200, {}, <<-JSON
      {
        "activeMembers": 0,
        "createdTime": "2013-07-12T15:22:47-02",
        "completedTime": "2013-07-12T15:22:47-02",
        "from": "+19703255647",
        "id": "conf-7qrj2t3lfixl4cgjcdonkna",
        "state": "created"
      }
      JSON
    ]}

    conference = @bandwidth.conference_info conference_id
    assert_equal 0, conference.active_members
    assert_equal Time.parse("2013-07-12T15:22:47-02"), conference.created_time
    assert_equal Time.parse("2013-07-12T15:22:47-02"), conference.completed_time
    assert_equal "+19703255647", conference.from
    assert_equal "conf-7qrj2t3lfixl4cgjcdonkna", conference.id
    assert_equal "created", conference.state
  end

  it "terminates conference" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"

    @bandwidth.stub.post("/conferences/#{conference_id}") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal "completed", parsed_body['state']

      [200, {}, ""]
    end

    @bandwidth.conference_terminate conference_id
  end

  it "mutes conference" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"

    @bandwidth.stub.post("/conferences/#{conference_id}") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal true, parsed_body['mute']

      [200, {}, ""]
    end

    @bandwidth.conference_mute conference_id, true
  end

  it "mutes conference" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"

    @bandwidth.stub.post("/conferences/#{conference_id}") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal false, parsed_body['mute']

      [200, {}, ""]
    end

    @bandwidth.conference_mute conference_id, false
  end

  it "plays audio to conference" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"
    audio_url = "http://example.com/audio.mp3"
    audio = Bandwidth::Audio::File.new audio_url

    @bandwidth.stub.post("/conferences/#{conference_id}/audio") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal audio_url, parsed_body['fileUrl']

      [200, {}, ""]
    end

    @bandwidth.conference_play conference_id, audio
  end

  it "adds member to a conference" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"
    call_id = "c-oajnekkhmazwhg4g5rfvsaa"
    member_id = "member-ae4b8krsskpuvnw6nsitg78"


    @bandwidth.stub.post("/conferences/#{conference_id}/members") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal call_id, parsed_body['callId']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/conferences/#{conference_id}/members/#{member_id}"}, ""]
    end

    assert_equal member_id, @bandwidth.conference_add(conference_id, call_id)
  end

  it "lists members of conference" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"

    @bandwidth.stub.get("/conferences/#{conference_id}/members") do |request|
      page = request[:params]['page'].to_i
      if page > 0
        [200, {}, "[]"]
      else
        [200, {}, <<-JSON
          [
            {
              "addedTime": "2013-07-12T15:54:47-02",
              "removedTime": "2013-07-12T15:49:11-02",
              "hold": false,
              "id": "member-i3bgynrxllq3v3wiisiuz2q",
              "mute": false,
              "state": "active",
              "call": "https://localhost:8444/v1/users/u-sg3wn3asvjzwbneengn3mma/calls/c-lem5j6326b2nyrej7ieheki"
            },
            {
              "addedTime": "2013-07-12T15:55:12-02",
              "removedTime": "2013-07-12T15:49:11-02",
              "hold": false,
              "id": "member-ae4b8krsskpuvnw6nsitg78",
              "mute": false,
              "state": "active",
              "call": "https://localhost:8444/v1/users/u-sg3wn3asvjzwbneengn3mma/calls/c-pk45jbkdib8j3xaj7odmnj9"
            }
          ]
          JSON
        ]
      end
    end

    members = @bandwidth.conference_members conference_id
    assert_equal 2, members.size

    member = members.first
    assert_equal "member-i3bgynrxllq3v3wiisiuz2q", member.id
    assert_equal Time.parse("2013-07-12T15:54:47-02"), member.added_time
    assert_equal Time.parse("2013-07-12T15:49:11-02"), member.removed_time
    assert_equal false, member.hold
    assert_equal false, member.mute
    assert_equal "active", member.state
    assert_equal "c-lem5j6326b2nyrej7ieheki", member.call
  end

  it "removes member from conference" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"
    member_id = "member-ae4b8krsskpuvnw6nsitg78"

    @bandwidth.stub.post("/conferences/#{conference_id}/members/#{member_id}") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal "completed", parsed_body['state']

      [200, {}, ""]
    end

    @bandwidth.conference_member_remove conference_id, member_id
  end

  it "mutes conference member" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"
    member_id = "member-ae4b8krsskpuvnw6nsitg78"

    @bandwidth.stub.post("/conferences/#{conference_id}/members/#{member_id}") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal true, parsed_body['mute']

      [200, {}, ""]
    end

    @bandwidth.conference_member_mute conference_id, member_id, true
  end

  it "puts conference mebmer on hold" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"
    member_id = "member-ae4b8krsskpuvnw6nsitg78"

    @bandwidth.stub.post("/conferences/#{conference_id}/members/#{member_id}") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal true, parsed_body['hold']

      [200, {}, ""]
    end

    @bandwidth.conference_member_hold conference_id, member_id, true
  end

  it "plays audio to conference member" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"
    member_id = "member-ae4b8krsskpuvnw6nsitg78"
    audio_url = "http://example.com/audio.mp3"
    audio = Bandwidth::Audio::File.new audio_url

    @bandwidth.stub.post("/conferences/#{conference_id}/members/#{member_id}/audio") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal audio_url, parsed_body['fileUrl']

      [200, {}, ""]
    end

    @bandwidth.conference_member_play conference_id, member_id, audio
  end

  it "retrieves information about particular conference member" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"
    member_id = "member-ae4b8krsskpuvnw6nsitg78"

    @bandwidth.stub.get("/conferences/#{conference_id}/members/#{member_id}") {[200, {}, <<-JSON
      {
        "addedTime": "2013-07-12T15:47:04-03",
        "hold": false,
        "id": "member-k26dzhtxwiepymkqq5vxc5q",
        "mute": false,
        "removedTime": "2013-07-12T15:49:11-02",
        "state": "completed",
        "call": "https://localhost:8444/v1/users/u-sg3wn3asvjzwbneengn3mma/calls/c-o754gpqvtxtdtfh6ebshl3y"
      }
      JSON
    ]}

    member = @bandwidth.conference_member_info conference_id, member_id
    assert_equal "member-k26dzhtxwiepymkqq5vxc5q", member.id
    assert_equal Time.parse("2013-07-12T15:47:04-03"), member.added_time
    assert_equal Time.parse("2013-07-12T15:49:11-02"), member.removed_time
    assert_equal false, member.hold
    assert_equal false, member.mute
    assert_equal "completed", member.state
    assert_equal "c-o754gpqvtxtdtfh6ebshl3y", member.call
  end
end
