module Bandwidth
  module API
    module Conferences

      def conference phone_number
        _body, headers = post "conferences", from: phone_number

        headers['location'].match(/[^\/]+$/)[0]
      end

      def conference_info conference_id
        conference, _headers = get "conferences/#{conference_id}"

        Types::Conference.new conference
      end

      def conference_terminate conference_id
        post "conferences/#{conference_id}", state: 'completed'

        nil
      end

      def conference_mute conference_id, mute
        post "conferences/#{conference_id}", mute: !!mute

        nil
      end

      def conference_play conference_id, audio
        post "conferences/#{conference_id}/audio", audio.to_hash

        nil
      end

      def conference_add conference_id, call_id
        _body, headers = post "conferences/#{conference_id}/members", callId: call_id

        headers['location'].match(/[^\/]+$/)[0]
      end

      def conference_members conference_id
        members, _headers = get "conferences/#{conference_id}/members"

        members.map do |member|
          Types::ConferenceMember.new member
        end
      end

      def conference_member_remove conference_id, member_id
        post "conferences/#{conference_id}/members/#{member_id}", state: 'completed'

        nil
      end

      def conference_member_mute conference_id, member_id, mute
        post "conferences/#{conference_id}/members/#{member_id}", mute: true

        nil
      end

      def conference_member_hold conference_id, member_id, hold
        post "conferences/#{conference_id}/members/#{member_id}", hold: true

        nil
      end

      def conference_member_play conference_id, member_id, audio
        post "conferences/#{conference_id}/members/#{member_id}/audio", audio.to_hash

        nil
      end

      def conference_member_info conference_id, member_id
        member, _headers = get "conferences/#{conference_id}/members/#{member_id}"

        Types::ConferenceMember.new member
      end
    end
  end
end
