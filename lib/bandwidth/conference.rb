module Bandwidth
  CONFERENCE_PATH = 'conferences'
  class Conference
    extend ClientWrapper
    include ApiItem
    include PlayAudioExtensions

    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{CONFERENCE_PATH}/#{id}"))[0]
      Conference.new(item, client)
    end
    wrap_client_arg :get

    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(CONFERENCE_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create

    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}"), data)[0]
    end

    def mute()
      update(:mute => true)
    end

    def complete()
      update(:state => 'completed')
    end


    def play_audio(data)
      @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}/audio"), data)[0]
    end

    def create_member(data)
      headers = @client.make_request(:post, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}/members"), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      get_member(id)
    end

    def get_member(member_id)
      member = ConferenceMember.new(@client.make_request(:get, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}/members/#{member_id}"))[0],
                           @client)
      member.conference_id = id
      member
    end

    def get_members()
      @client.make_request(:get, @client.concat_user_path("#{CONFERENCE_PATH}/#{id}/members"))[0].map do |i|
        member = ConferenceMember.new(i, @client)
        member.conference_id = id
        member
      end
    end
  end
end
