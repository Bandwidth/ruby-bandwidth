module Bandwidth
  # Conference member
  class ConferenceMember
    extend ClientWrapper
    include ApiItem
    include PlayAudioExtensions
    attr_accessor :conference_id

    # Update a conference member. E.g.: remove from call, mute, hold, etc.
    # @param data [Hash] changed data
    # @example
    #   member.update(:mute=>true)
    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{@conference_id}/members/#{id}"), data)[0]
    end

    # Play audio to a conference member
    # @param data [Hash] audio data
    # @example
    #   member.play_audio(:file_url => "http://host1")
    def play_audio(data)
      @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{@conference_id}/members/#{id}/audio"), data)[0]
    end
  end
end
