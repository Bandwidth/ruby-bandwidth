module Bandwidth
  module API
    module Bridges

      def bridges
        bridges, _headers = get 'bridges'

        bridges.map do |bridge|
          Types::Bridge.new bridge
        end
      end

      def bridge call_id1, call_id2, bridge_audio=true
        post "bridges", {callIds: [call_id1, call_id2], bridgeAudio: bridge_audio}

        nil
      end

      def bridge_info bridge_id
        bridge, _headers = get "bridges/#{bridge_id}"

        Types::Bridge.new bridge
      end

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

      def bridged_calls bridge_id
        calls, _headers = get "bridges/#{bridge_id}/calls"

        calls.map do |call|
          Types::BridgedCall.new call
        end
      end

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
