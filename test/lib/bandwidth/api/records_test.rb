require_relative '../../../test_helper'

describe Bandwidth::API::Records do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "returns a list of records" do
    @bandwidth.stub.get('/recordings') {[200, {}, <<-JSON
      [
        {
          "endTime": "2013-02-08T13:17:12.181Z",
          "id": "rec-togfrwqp2bxxezstzbzadra",
          "media": "https://.../v1/users/.../media/c-j4gferrrn72ivf3ov56ccay-1.wav",
          "call": "https://.../v1/users/.../calls/c-j4gferrrn72ivf3ov56ccay",
          "startTime": "2013-02-08T13:15:47.587Z",
          "state": "complete"
        },
        {
          "endTime": "2013-02-08T14:05:15.587Z",
          "id": "rec-2nsxh4izqj6effol6byo5aq",
          "media": "https://.../v1/users/.../media/c-j4gferrrn72ivf3ov56ccay-2.wav",
          "call": "https://.../v1/users/.../calls/c-j4gferrrn72ivf3ov56ccay",
          "startTime": "2013-02-08T14:03:47.587Z",
          "state": "complete"
        },
        {
          "endTime": "2013-02-08T13:34:07.507Z",
          "id": "rec-iyrrghf45ge2w267dllmhyq",
          "media": "https://.../v1/users/.../media/c-cyalm3upp7yp6ih4mkx7lci-1.wav",
          "call": "https://.../v1/users/.../calls/c-cyalm3upp7yp6ih4mkx7lci",
          "startTime": "2013-02-08T13:28:47.587Z",
          "state": "complete"
        }
      ]
      JSON
    ]}

    records = @bandwidth.records
    assert_equal 3, records.size

    record = records.first

    assert_equal Time.parse("2013-02-08T13:17:12.181Z"), record.end_time
    assert_equal Time.parse("2013-02-08T13:15:47.587Z"), record.start_time
    assert_equal "rec-togfrwqp2bxxezstzbzadra", record.id
    assert_equal "c-j4gferrrn72ivf3ov56ccay-1.wav", record.media
    assert_equal "c-j4gferrrn72ivf3ov56ccay", record.call
    assert_equal "complete", record.state
  end

  it "returns allocated phone number information" do
    record_id = "rec-togfrwqp2bxxezstzbzadra"

    @bandwidth.stub.get("/recordings/#{record_id}") {[200, {}, <<-JSON
      {
        "endTime": "2013-02-08T13:17:12.181Z",
        "id": "rec-togfrwqp2bxxezstzbzadra",
        "media": "https://.../v1/users/.../media/c-j4gferrrn72ivf3ov56ccay-1.wav",
        "call": "https://.../v1/users/.../calls/c-j4gferrrn72ivf3ov56ccay",
        "startTime": "2013-02-08T13:15:47.587Z",
        "state": "complete"
      }
      JSON
    ]}

    record = @bandwidth.record record_id

    assert_equal Time.parse("2013-02-08T13:17:12.181Z"), record.end_time
    assert_equal Time.parse("2013-02-08T13:15:47.587Z"), record.start_time
    assert_equal "rec-togfrwqp2bxxezstzbzadra", record.id
    assert_equal "c-j4gferrrn72ivf3ov56ccay-1.wav", record.media
    assert_equal "c-j4gferrrn72ivf3ov56ccay", record.call
    assert_equal "complete", record.state
  end
end
