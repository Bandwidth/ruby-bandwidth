require_relative '../../../test_helper'

describe Bandwidth::API::Calls do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "lists calls" do
    @bandwidth.stub.get('/calls') do |request|
      page = request[:params]['page'].to_i
      if page > 0
        [200, {}, "[]"]
      else
        [200, {}, <<-JSON
          [
            {
              "id": "c-clgsmnrn4ruwdx36rxf7zoi",
              "direction": "out",
              "from": "+19195551212",
              "to": "+13125556666",
              "state": "completed",
              "startTime": "2013-02-08T13:15:47.587Z",
              "activeTime": "2013-02-08T13:15:52.347Z",
              "endTime": "2013-02-08T13:15:55.887Z",
              "chargeableDuration": 60
            },
            {
              "id": "c-xytsl6nfcayzsxdbqq7q36i",
              "direction": "out",
              "from": "+13125556666",
              "to": "+13125557777",
              "state": "active",
              "startTime": "2013-02-08T13:15:47.587Z",
              "activeTime": "2013-02-08T13:15:52.347Z",
              "endTime": "2013-02-08T13:15:55.887Z",
              "chargeableDuration": 30
            }
          ]
          JSON
        ]
      end
    end

    calls = @bandwidth.calls

    assert_equal 2, calls.size
    call = calls.first

    assert_equal "c-clgsmnrn4ruwdx36rxf7zoi", call.id
    assert_equal "out", call.direction
    assert_equal "+19195551212", call.from
    assert_equal "+13125556666", call.to
    assert_equal "completed", call.state
    assert_equal Time.parse("2013-02-08T13:15:47.587Z"), call.start_time
    assert_equal Time.parse("2013-02-08T13:15:52.347Z"), call.active_time
    assert_equal Time.parse("2013-02-08T13:15:55.887Z"), call.end_time
    assert_equal 60, call.chargeable_duration
  end

  it "filters calls by parameters: from" do
    from = "+19195551212"
    @bandwidth.stub.get("/calls") do |request|
      assert_equal from, request[:params]['from']
      [200, {}, "[]"]
    end

    @bandwidth.calls from: from
  end

  it "filters calls by parameters: to" do
    to = "+13125556666"
    @bandwidth.stub.get("/calls") do |request|
      assert_equal to, request[:params]['to']
      [200, {}, "[]"]
    end

    @bandwidth.calls to: to
  end

  it "filters calls by parameters: bridge id" do
    bridge_id = "brg-72x6e5d6gbthaw52vcsouyq"
    @bandwidth.stub.get("/calls") do |request|
      assert_equal bridge_id, request[:params]['bridgeId']
      [200, {}, "[]"]
    end

    @bandwidth.calls bridge_id: bridge_id
  end

  it "filters calls by parameters: conference id" do
    conference_id = "conf-7qrj2t3lfixl4cgjcdonkna"
    @bandwidth.stub.get("/calls") do |request|
      assert_equal conference_id, request[:params]['conferenceId']
      [200, {}, "[]"]
    end

    @bandwidth.calls conference_id: conference_id
  end

  it "makes a call and returns call_id when making a call" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"

    @bandwidth.stub.post('/calls') {[201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/calls/#{call_id}"}, ""]}

    assert_equal call_id, @bandwidth.dial("+19195551212", "+13125556666")
  end

  it "passes parameters when making a call" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    from = "+19195551212"
    to = "+13125556666"

    @bandwidth.stub.post("/calls") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal from, parsed_body['from']
      assert_equal to, parsed_body['to']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/calls/#{call_id}"}, ""]
    end

    @bandwidth.dial from, to
  end

  it "passes extra parameters when making a call: recording" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"

    @bandwidth.stub.post("/calls") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal true, parsed_body['recordingEnabled']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/calls/#{call_id}"}, ""]
    end

    @bandwidth.dial "+19195551212", "+13125556666", recording_enabled: true
  end

  it "passes extra parameters when making a call: bridge id" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    bridge_id = "brg-72x6e5d6gbthaw52vcsouyq"

    @bandwidth.stub.post("/calls") do |request|
      parsed_body = JSON.parse request[:body]

      assert_equal bridge_id, parsed_body['bridgeId']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/calls/#{call_id}"}, ""]
    end

    @bandwidth.dial "+19195551212", "+13125556666", bridge_id: bridge_id
  end

  it "gets call information by id" do
    call_id = "c-xytsl6nfcayzsxdbqq7q36i"

    @bandwidth.stub.get("/calls") do |request|
      assert_equal call_id, request[:params]['callId']

      [200, {}, <<-JSON
        {
          "id": "c-xytsl6nfcayzsxdbqq7q36i",
          "direction": "out",
          "from": "+19195551212",
          "to": "+13125556666",
          "state": "active",
          "startTime": "2013-02-08T13:15:47.587Z",
          "activeTime": "2013-02-08T13:15:52.347Z",
          "endTime": "2013-02-08T13:15:55.887Z",
          "chargeableDuration": 30
        }
      JSON
      ]
    end

    call = @bandwidth.call_info call_id

    assert_equal call_id, call_id
    assert_equal "out", call.direction
    assert_equal "+19195551212", call.from
    assert_equal "+13125556666", call.to
    assert_equal "active", call.state
    assert_equal Time.parse("2013-02-08T13:15:47.587Z"), call.start_time
    assert_equal Time.parse("2013-02-08T13:15:52.347Z"), call.active_time
    assert_equal Time.parse("2013-02-08T13:15:55.887Z"), call.end_time
    assert_equal 30, call.chargeable_duration
  end

  it "hangs up" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"

    @bandwidth.stub.post("/calls/#{call_id}") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal "completed", parsed_body['state']

      [200, {}, ""]
    end

    @bandwidth.hangup call_id
  end

  it "transfers" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    new_call_id = "c-alsnbemjc6mvjhefjdngptq"
    target = "+13125556666"

    @bandwidth.stub.post("/calls/#{call_id}") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal "transferring", parsed_body['state']
      assert_equal target, parsed_body['transferTo']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/calls/#{new_call_id}"}, ""]
    end

    assert_equal new_call_id, @bandwidth.transfer(call_id, target)
  end

  it "transfers and sets caller id" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    new_call_id = "c-alsnbemjc6mvjhefjdngptq"
    target = "+13125556666"
    transfer_caller_id = "+19195551212"

    @bandwidth.stub.post("/calls/#{call_id}") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal transfer_caller_id, parsed_body['transferCallerId']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/calls/#{new_call_id}"}, ""]
    end

    @bandwidth.transfer call_id, target, transfer_caller_id: transfer_caller_id
  end

  it "transfers and plays audio" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    new_call_id = "c-alsnbemjc6mvjhefjdngptq"
    target = "+13125556666"
    audio_url = "http://example.com/audio.mp3"

    @bandwidth.stub.post("/calls/#{call_id}") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal audio_url, parsed_body['whisperAudio']['fileUrl']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/calls/#{new_call_id}"}, ""]
    end

    audio = Bandwidth::Audio::File.new audio_url
    @bandwidth.transfer call_id, target, audio: audio
  end

  it "transfers and says" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    new_call_id = "c-alsnbemjc6mvjhefjdngptq"
    target = "+13125556666"
    sentence = "Hello, thank you for calling."

    @bandwidth.stub.post("/calls/#{call_id}") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal sentence, parsed_body['whisperAudio']['sentence']

      [201, {location: "https://api.catapult.inetwork.com/v1/users/user_id/calls/#{new_call_id}"}, ""]
    end

    audio = Bandwidth::Audio::Sentence.new sentence
    @bandwidth.transfer call_id, target, audio: audio
  end

  it "turns on recording state" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"

    @bandwidth.stub.post("/calls/#{call_id}") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal "true", parsed_body['recordingEnabled']

      [200, {}, ""]
    end

    @bandwidth.recording_enabled call_id, true
  end

  it "turns off recording state" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"

    @bandwidth.stub.post("/calls/#{call_id}") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal "false", parsed_body['recordingEnabled']

      [200, {}, ""]
    end

    @bandwidth.recording_enabled call_id, false
  end

  it "plays audio to the call" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    audio_url = "http://example.com/audio.mp3"
    audio = Bandwidth::Audio::File.new audio_url

    @bandwidth.stub.post("/calls/#{call_id}/audio") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal audio_url, parsed_body['fileUrl']

      [200, {}, ""]
    end

    @bandwidth.play call_id, audio
  end

  it "says to the call" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    sentence = "Hello, thank you for calling."
    audio = Bandwidth::Audio::Sentence.new sentence

    @bandwidth.stub.post("/calls/#{call_id}/audio") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal sentence, parsed_body['sentence']

      [200, {}, ""]
    end

    @bandwidth.play call_id, audio
  end

  it "supports general options" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    sentence = "Hello, thank you for calling."
    audio = Bandwidth::Audio::Sentence.new sentence, loop_enabled: true

    @bandwidth.stub.post("/calls/#{call_id}/audio") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal true, parsed_body['loopEnabled']

      [200, {}, ""]
    end

    @bandwidth.play call_id, audio
  end

  it "supports sentence options" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    audio = Bandwidth::Audio::Sentence.new "Guten Tag",
      locale: Bandwidth::Audio::Sentence::LOCALE_DE,
      gender: Bandwidth::Audio::Sentence::MALE

    @bandwidth.stub.post("/calls/#{call_id}/audio") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal Bandwidth::Audio::Sentence::MALE, parsed_body['gender']
      assert_equal Bandwidth::Audio::Sentence::LOCALE_DE, parsed_body['locale']

      [200, {}, ""]
    end

    @bandwidth.play call_id, audio
  end

  it "sends dtmf" do
    call_id = "c-clgsmnrn4ruwdx36rxf7zoi"
    dtmf = "1234"

    @bandwidth.stub.post("/calls/#{call_id}/dtmf") do |request|
      parsed_body = JSON.parse request[:body]
      assert_equal dtmf, parsed_body['dtmfOut']

      [200, {}, ""]
    end

    @bandwidth.dtmf call_id, dtmf
  end

  it "gathers dtmf" do
    call_id = "c-alsnbemjc6mvjhefjdngptq"
    dtmf_digits = "#123"

    @bandwidth.stub.get("/calls/#{call_id}/gather") { [200, {}, <<-JSON
      {
        "eventType": "gather",
        "callId": "#{call_id}",
        "digits": "#{dtmf_digits}",
        "state": "terminating-digit",
        "terminatingDigit": "*",
        "tag": "abc123"
      }
      JSON
    ]}

    dtmf = @bandwidth.gather call_id
    assert_equal dtmf_digits, dtmf.digits
    assert_equal "terminating-digit", dtmf.state
    assert_equal "*", dtmf.terminating_digit
    assert_equal "abc123", dtmf.tag
  end

  it "passes parameters to gather: max_digits" do
    call_id = "c-alsnbemjc6mvjhefjdngptq"

    @bandwidth.stub.get("/calls/#{call_id}/gather") do |request|
      assert_equal "3", request[:params]['maxDigits']

      [200, {}, "{}"]
    end

    @bandwidth.gather call_id, max_digits: 3
  end

  it "passes parameters to gather: inter_digit_timeout" do
    call_id = "c-alsnbemjc6mvjhefjdngptq"

    @bandwidth.stub.get("/calls/#{call_id}/gather") do |request|
      assert_equal "10", request[:params]['interDigitTimeout']

      [200, {}, "{}"]
    end

    @bandwidth.gather call_id, inter_digit_timeout: 10
  end

  it "passes parameters to gather: terminating_digit" do
    call_id = "c-alsnbemjc6mvjhefjdngptq"

    @bandwidth.stub.get("/calls/#{call_id}/gather") do |request|
      assert_equal "0#*", request[:params]['terminatingDigits']

      [200, {}, "{}"]
    end

    @bandwidth.gather call_id, terminating_digits: "0#*"
  end

  it "passes parameters to gather: tag" do
    call_id = "c-alsnbemjc6mvjhefjdngptq"

    @bandwidth.stub.get("/calls/#{call_id}/gather") do |request|
      assert_equal 'abc123', request[:params]['tag']

      [200, {}, "{}"]
    end

    @bandwidth.gather call_id, tag: 'abc123'
  end

  it "passes parameters to gather: audio" do
    call_id = "c-alsnbemjc6mvjhefjdngptq"
    audio_url = "http://example.com/audio.mp3"
    audio = Bandwidth::Audio::File.new audio_url, bargeable: false

    @bandwidth.stub.get("/calls/#{call_id}/gather") do |request|
      assert_equal audio_url, request[:params]['prompt']['fileUrl']
      assert_equal "false", request[:params]['prompt']['bargeable']

      [200, {}, "{}"]
    end

    @bandwidth.gather call_id, audio: audio
  end

  it "retrieves all recordings related to the call" do
    call_id = "c-alsnbemjc6mvjhefjdngptq"
    record_id = "rec-togfrwqp2bxxezstzbzadra"
    media_id = "c-j4gferrrn72ivf3ov56ccay-1.wav"
    end_time = "2013-02-08T12:06:55.007Z"
    start_time = "2013-02-08T12:05:17.807Z"

    @bandwidth.stub.get("/calls/#{call_id}/recordings") do |request|
      page = request[:params]['page'].to_i
      if page > 0
        [200, {}, "[]"]
      else
        [200, {}, <<-JSON
          [
            {
              "endTime": "#{end_time}",
              "id": "#{record_id}",
              "media": "https://.../v1/users/.../media/#{media_id}",
              "startTime": "#{start_time}",
              "state": "complete"
            },
            {
              "endTime": "2013-02-08T13:15:55.887Z",
              "id": "rec-2nsxh4izqj6effol6byo5aq",
              "media": "https://.../v1/users/.../media/c-j4gferrrn72ivf3ov56ccay-2.wav",
              "startTime": "2013-02-08T13:15:55.887Z",
              "state": "complete"
            }
          ]
          JSON
        ]
      end
    end

    records = @bandwidth.call_records call_id
    assert_equal 2, records.size

    record = records.first
    assert_equal Time.parse(end_time), record.end_time
    assert_equal Time.parse(start_time), record.start_time
    assert_equal record_id, record.id
    assert_equal media_id, record.media
    assert_equal "complete", record.state
  end
end
