module Bandwidth
  module API
    module Conferences

      # Creates a conference with no members
      #
      # @param [String] phone_number Phone number to use
      #
      # @return [String] Unique conference id
      #
      # @example
      #   conference_id = bandwidth.conference "+19195551212" # => "conf-7qrj2t3lfixl4cgjcdonkna"
      #
      def conference phone_number
        _body, headers = post "conferences", from: phone_number

        headers['location'].match(/[^\/]+$/)[0]
      end

      # Retrieve conference information
      #
      # @param [String] conference_id Unique conference id
      #
      # @example
      #   bandwidth.conference_info "conf-7qrj2t3lfixl4cgjcdonkna"
      #
      def conference_info conference_id
        conference, _headers = get "conferences/#{conference_id}"

        Types::Conference.new conference
      end

      # Terminate conference
      #
      # @param [String] conference_id Unique conference id
      #
      # @example
      #   bandwidth.conference_terminate "conf-7qrj2t3lfixl4cgjcdonkna"
      #
      def conference_terminate conference_id
        post "conferences/#{conference_id}", state: 'completed'

        nil
      end

      # Muting conference
      #
      # @param [String] conference_id Unique conference id
      # @param [TrueClass, FalseClass] mute Turn muting on or off
      #
      # @example
      #   bandwidth.conference_mute "conf-7qrj2t3lfixl4cgjcdonkna", true
      #
      def conference_mute conference_id, mute
        post "conferences/#{conference_id}", mute: !!mute

        nil
      end

      # Play an audio/speak a sentence in the conference
      #
      # @param [String] conference_id Unique conference id
      # @param [Audio::Sentence, Audio::File] audio Audio file to play or text to speak
      #
      # @example Plays an audio file in a conference
      #   audio_file = Bandwidth::Audio::File.new "http://example.com/audio.mp3"
      #   bandwidth.conference_play "conf-7qrj2t3lfixl4cgjcdonkna", audio_file
      #
      # @example Speak a sentence in a conference
      #   sentence = Bandwidth::Audio::Sentence.new "Hello, thank you for calling."
      #   bandwidth.conference_play "conf-7qrj2t3lfixl4cgjcdonkna", sentence
      #
      # @note See [Audio::Sentence] and [Audio::File] for more options
      #
      def conference_play conference_id, audio
        post "conferences/#{conference_id}/audio", audio.to_hash

        nil
      end

      # Add a member to a conference
      #
      # @param [String] conference_id Unique conference id
      # @param [String] call_id Call id
      #
      # @return [String] Unique member id
      #
      # @example
      #   call_id = bandwidth.dial "+19195551212", "+13125556666"
      #   member_id = bandwidth.conference_add "conf-7qrj2t3lfixl4cgjcdonkna", call_id # => "member-ae4b8krsskpuvnw6nsitg78"
      #
      def conference_add conference_id, call_id
        _body, headers = post "conferences/#{conference_id}/members", callId: call_id

        headers['location'].match(/[^\/]+$/)[0]
      end

      # List all members from a conference
      #
      # @param [String] conference_id Unique conference id
      #
      # @return [Array<Type::ConferenceMember>]
      #
      # @example
      #   members = bandwidth.conference_members "conf-7qrj2t3lfixl4cgjcdonkna"
      #
      #   member = members.first
      #   member.id # => "member-i3bgynrxllq3v3wiisiuz2q"
      #   member.added_time # => 2013-07-12 17:54:47 UTC
      #   member.hold # => false
      #   member.mute # => false
      #   member.state # => "active"
      #   member.call # => "c-lem5j6326b2nyrej7ieheki"
      #
      def conference_members conference_id
        members, _headers = get "conferences/#{conference_id}/members"

        members.map do |member|
          Types::ConferenceMember.new member
        end
      end

      # Remove member from conference
      #
      # @param [String] conference_id Unique conference id
      # @param [String] member_id Unique member id
      #
      # @example
      #   bandwidth.conference_member_remove conference_id, member_id
      #
      def conference_member_remove conference_id, member_id
        post "conferences/#{conference_id}/members/#{member_id}", state: 'completed'

        nil
      end

      # Muting a member
      #
      # @param [String] conference_id Unique conference id
      # @param [String] member_id Unique member id
      # @param [TrueClass, FalseClass] mute Turn member muting on or off
      #
      # @example
      #   bandwidth.conference_member_mute conference_id, member_id, true
      #
      def conference_member_mute conference_id, member_id, mute
        post "conferences/#{conference_id}/members/#{member_id}", mute: true

        nil
      end

      # Putting a member on hold
      #
      # @param [String] conference_id Unique conference id
      # @param [String] member_id Unique member id
      # @param [TrueClass, FalseClass] hold Hold member on or off
      #
      # @example
      #   bandwidth.conference_member_hold conference_id, member_id, true
      #
      def conference_member_hold conference_id, member_id, hold
        post "conferences/#{conference_id}/members/#{member_id}", hold: true

        nil
      end

      # Play an audio/speak a sentence to a conference member
      #
      # @param [String] conference_id Unique conference id
      # @param [String] member_id Unique member id
      # @param [Audio::Sentence, Audio::File] audio Audio file to play or text to speak
      #
      # @example Plays an audio file to a member of a conference
      #   audio_file = Bandwidth::Audio::File.new "http://example.com/audio.mp3"
      #   bandwidth.conference_member_play "conf-7qrj2t3lfixl4cgjcdonkna", "member-i3bgynrxllq3v3wiisiuz2q", audio_file
      #
      # @example Speak a sentence to a member of a conference
      #   sentence = Bandwidth::Audio::Sentence.new "Hello, thank you for calling."
      #   bandwidth.conference_member_play "conf-7qrj2t3lfixl4cgjcdonkna", "member-i3bgynrxllq3v3wiisiuz2q", sentence
      #
      # @note See [Audio::Sentence] and [Audio::File] for more options
      #
      def conference_member_play conference_id, member_id, audio
        post "conferences/#{conference_id}/members/#{member_id}/audio", audio.to_hash

        nil
      end

      # Retrieve information about a particular conference member
      #
      # @param [String] conference_id Unique conference id
      # @param [String] member_id Unique member id
      #
      # @return [Types::ConferenceMember]
      #
      # @example
      #   member = bandwidth.conference_member_info conference_id, member_id
      #   member.id # => "member-i3bgynrxllq3v3wiisiuz2q"
      #   member.added_time # => 2013-07-12 17:54:47 UTC
      #   member.hold # => false
      #   member.mute # => false
      #   member.state # => "active"
      #   member.call # => "c-lem5j6326b2nyrej7ieheki"
      #
      def conference_member_info conference_id, member_id
        member, _headers = get "conferences/#{conference_id}/members/#{member_id}"

        Types::ConferenceMember.new member
      end
    end
  end
end
