module Bandwidth
  module API
    module Bridges

      # Get a list of previous bridges
      #
      # @return [Array<Types::Bridge>]
      #
      # @example Bridge two calls
      #   bridges = bandwidth.bridges # => [#<Bridge:0xa466c5c>, ...]
      #
      #   bridge = bridges.first
      #   bridge.id # => "brg-7cp5tvhydw4a3esxwpww5qa"
      #   bridge.state # => "completed"
      #   bridge.bridge_audio # => true
      #   bridge.created_time => 2013-04-22 13:55:30 UTC
      #   bridge.activated_time => 2013-04-22 13:55:30 UTC
      #   bridge.completed_time => 2013-04-22 13:56:30 UTC
      #
      # @example Bridge two calls without bridging audio
      #   bandwidth.bridge_info "brg-7cp5tvhydw4a3esxwpww5qa", false
      #
      def bridges
        bridges, _headers = get 'bridges'

        bridges.map do |bridge|
          Types::Bridge.new bridge
        end
      end

      # Create a bridge
      #
      # @param [String] call_id1 Call id to bridge
      # @param [String] call_id2 Second call id to bridge
      # @param [TrueClass, FalseClass, nil] bridge_audio Bridge audio from the very beginning (true by default)
      #
      # @example
      #   bandwidth.bridge "c-mxdxhidpjr6a2bp2lxq6vaa", "c-c2rui2kbrldsfgjhlvlnjaq"
      #
      def bridge call_id1, call_id2, bridge_audio=true
        post "bridges", {callIds: [call_id1, call_id2], bridgeAudio: bridge_audio}

        nil
      end

      # Get information about a specific bridge
      #
      # @param [String] bridge_id Bridge id
      #
      # @example
      #   bandwidth.bridge_info "brg-7cp5tvhydw4a3esxwpww5qa" # => <Bridge:0xa466c5c>
      #
      def bridge_info bridge_id
        bridge, _headers = get "bridges/#{bridge_id}"

        Types::Bridge.new bridge
      end

      # Bridging audio
      #
      # @param [String] bridge_id Bridge id
      # @param [TrueClass, FalseClass] bridge_audio Turn audio bridging on or off
      #
      # @example
      #   bandwidth.bridge_audio "brg-7cp5tvhydw4a3esxwpww5qa", true
      #
      def bridge_audio bridge_id, bridge_audio
        post "bridges/#{bridge_id}", {bridgeAudio: bridge_audio}

        nil
      end

      # Play an audio or speak a sentence in a bridge
      #
      # @param [String] bridge_id Bridge unique id
      # @param [Audio::Sentence, Audio::File] audio Audio file to play or text to speak
      #
      # @example Plays an audio file in a bridge
      #   audio_file = Bandwidth::Audio::File.new "http://example.com/audio.mp3"
      #   bandwidth.bridge_play call_id, audio_file
      #
      # @example Speak a sentence in a bridge
      #   sentence = Bandwidth::Audio::Sentence.new "Hello, thank you for calling."
      #   bandwidth.bridge_play call_id, sentence
      #
      # @note See [Audio::Sentence] and [Audio::File] for more options
      #
      def bridge_play bridge_id, audio
        post "bridges/#{bridge_id}/audio", audio.to_hash

        nil
      end

      # Get the calls that are on the bridge
      #
      # @param [String] bridge_id Bridge unique id
      #
      # @return [Array<Types::Bridge>]
      #
      # @example
      #   calls = bandwidth.bridged_calls "brg-7cp5tvhydw4a3esxwpww5qa" # => [#<BridgedCall:0x9906e34>, #<BridgedCall:0xaf0f208>]
      #
      #   call = calls.first
      #   call.bridge_id # => "brg-7cp5tvhydw4a3esxwpww5qa"
      #   call.id # => "c-clgsmnrn4ruwdx36rxf7zoi"
      #   call.direction # => "out"
      #   call.from # => "+19195551212"
      #   call.to # => "+13125556666"
      #   call.state # => "active"
      #   call.startTime # => 2013-02-08 13:15:47 UTC
      #   call.activeTime # => 2013-02-08 13:15:52 UTC
      #   call.recording_enabled # => false
      #
      def bridged_calls bridge_id
        calls, _headers = get "bridges/#{bridge_id}/calls"

        calls.map do |call|
          Types::BridgedCall.new call
        end
      end

      # Destroy bridge
      # Removes all calls from bridge. It will also change the bridge state to 'completed' and this bridge can not be updated anymore
      #
      # @param [String] bridge_id Bridge unique id
      #
      # @example
      #   bandwidth.unbridge bridge_id
      #
      def unbridge bridge_id
        post "bridges/#{bridge_id}", {callIds: []}

        nil
      end

      module States
        # @return [String] The bridge was created but the audio was never bridged
        CREATED = 'created'.freeze

        # @return [String] The bridge has two active calls and the audio was already bridged before
        ACTIVE = 'active'.freeze

        # @return [String] The bridge calls are on hold (bridge_audio was set to false)
        HOLD = 'hold'.freeze

        # @return [String] The bridge was completed. The bridge is completed when all calls hangup or when all calls are removed from bridge
        COMPLETED = 'completed'.freeze

        # @return [String] Some error was detected in bridge
        ERROR = 'error'.freeze
      end
    end
  end
end
