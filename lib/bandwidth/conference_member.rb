module Bandwidth
  class ConferenceMember
    extend ClientWrapper
    include ApiItem
    include PlayAudioExtensions
    attr_accessor :conference_id
    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{@conference_id}/members/#{id}"), data)[0]
    end
    def play_audio(data)
      @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{@conference_id}/members/#{id}/audio"), data)[0]
    end
  end
end
