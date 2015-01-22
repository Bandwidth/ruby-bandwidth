module Bandwidth
  CONFERENCE_PATH = 'conferences'
  #The Conference resource allows you create conferences, add members to it, play audio and other things related to conferencing.
  class Conference
    extend ClientWrapper
    include ApiItem
    include PlayAudioExtensions

    # Get information about a conference
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of a conference
    # @return [Conference] conference instance
    # @example
    #   conference = Conference.get(client, "id")
    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{CONFERENCE_PATH}/#{id}"))[0]
      Conference.new(item, client)
    end
    wrap_client_arg :get

    # Create a conference.
    # @param client [Client] optional client instance to make requests
    # @param data [Hash] data to create a conference
    # @return [Conference] created conference
    # @example
    #   conference = Conference.create(client, :from => "number")
    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(CONFERENCE_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create

    # Update a conference
    # @param data [Hash] changed data
    # @example
    #   conference.update(:mute=>false)
    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}"), data)[0]
    end

    # Prevent all members from speaking
    def mute()
      update(:mute => true)
    end

    # Terminate Conference
    def complete()
      update(:state => 'completed')
    end

    # Play audio to a conference
    # @param data [Hash] audio options
    # @example
    #   conference.play_audio(:file_url=>"http://host1")
    def play_audio(data)
      @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}/audio"), data)[0]
    end

    # Add a member to a conference.
    # @param data [Hash] data to add member to a conference
    # @return [ConferenceMember] created member
    # @example
    #   member = conference.create_member(:call_id=>"id")
    def create_member(data)
      headers = @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}/members"), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      get_member(id)
    end

    # Retrieve information about a particular conference member
    # @param member_id [String] id of member
    # @return [ConferenceMember] member information
    # @example
    #   member = conference.get_member("id")
    def get_member(member_id)
      member = ConferenceMember.new(@client.make_request(:get, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}/members/#{member_id}"))[0],
                           @client)
      member.conference_id = id
      member
    end

    # List all members from a conference
    # @return [Array] array of ConferenceMember instances
    # @example
    #   members = conference.get_members()
    def get_members()
      @client.make_request(:get, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}/members"))[0].map do |i|
        member = ConferenceMember.new(i, @client)
        member.conference_id = id
        member
      end
    end
  end
end
