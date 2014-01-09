require_relative '../../../test_helper'
require 'stringio'

describe Bandwidth::API::Media do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "lists media files" do
    @bandwidth.stub.get("/media") do |request|
      page = request[:params]['page'].to_i
      if page > 0
        [200, {}, "[]"]
      else
        [200, {}, <<-JSON
          [
            {
              "contentLength": 561276,
              "mediaName": "house.jpg"
            },
            {
              "contentLength": 2703360,
              "mediaName": "mysong.mp3"
            },
            {
              "contentLength": 588,
              "mediaName": "test.txt"
            }
          ]
          JSON
        ]
      end
    end

    media = @bandwidth.media
    assert_equal 3, media.size

    medium = media.first
    assert_equal 561276, medium.content_length
    assert_equal "house.jpg", medium.media_name
  end

  it "uploads a file or string" do
    file_contents = "1234567890"
    media_name = "some_file.mp3"

    @bandwidth.stub.put("/media/#{media_name}") do |request|
      assert_equal file_contents, request[:body]
      assert_equal 10, request[:request_headers]['Content-Length']

      [200, {}, ""]
    end

    @bandwidth.upload media_name, StringIO.new(file_contents)
  end

  it "downloads medium" do
    file_contents = "1234567890"
    media_name = "some_file.mp3"

    @bandwidth.stub.get("/media/#{media_name}") do |request|
      [200, {}, file_contents]
    end

    data = @bandwidth.download media_name
    assert_equal file_contents, data
  end

  it "deletes media" do
    media_name = "some_file.mp3"

    @bandwidth.stub.delete("/media/#{media_name}") { [200, {}, ""] }

    @bandwidth.delete_media media_name
  end
end
