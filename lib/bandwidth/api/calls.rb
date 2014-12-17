module Bandwidth
  module API
    module Calls

      # Gets a list of active and historic calls you made or received
      #
      # @param [Hash] options Filtering options
      # @option options [String] :from Filter by sender
      # @option options [String] :to Filter by recipient
      # @option options [String] :bridge_id Filter by bridge id
      # @option options [String] :conference_id Filter by conference id
      #
      # @return [Array<Types::Call>]
      #
      # @example Gets a list of active and historic calls you made or received
      #   calls = bandwidth.calls # => [#<Call:0x9906e34>, ...]
      #
      #   call = calls.first
      #
      #   call.id # => "c-clgsmnrn4ruwdx36rxf7zoi"
      #   call.direction # => "out"
      #   call.from # => "+19195551212"
      #   call.to # => "+13125556666"
      #   call.state # => "completed"
      #   call.start_time # => 2013-02-08 13:15:47 UTC
      #   call.active_time # => 2013-02-08 13:15:52 UTC
      #   call.end_time # => 2013-02-08 13:15:55 UTC
      #   call.chargeable_duration # => 60
      #
      def calls options={}
        # TODO: raise AE if wrong options passed (all the methods)
        options.keep_if {|key, _v| [:to, :from, :bridge_id, :conference_id].include? key }

        LazyArray.new do |page, size|
          calls, _headers = get 'calls', options.merge(page: page, size: size)

          calls.map do |call|
            Types::Call.new call
          end
        end
      end

      # Make a phone call
      #
      # @param [String] from Phone number to call from
      # @param [String] to Phone number to call to
      # @param [Hash] options Options
      # @option options [Boolean] :recording_enabled This will make a call and start recording immediately
      # @option options [String] :bridge_id This will create a call in a bridge
      #
      # @return [String] Created call id
      #
      # @example Create a call in a bridge
      #   bridge_id = "brg-72x6e5d6gbthaw52vcsouyq"
      #   call_id = bandwidth.dial "+19195551212", "+13125556666", bridge_id: bridge_id
      #
      def dial from, to, options={}
        parameters = { from: from, to: to }
        options.keep_if {|key, _v| [:recording_enabled, :bridge_id, :callback_url].include? key }

        _body, headers = post 'calls', parameters.merge(options)
        headers['location'].match(/[^\/]+$/)[0]
      end

      # Get information about a call that was made or received
      #
      # @param [String] call_id Call id
      #
      # @return [Types::Call]
      #
      # @example Gets information about an active or completed call
      #   call = bandwidth.call_info "c-xytsl6nfcayzsxdbqq7q36i"
      #
      def call_info call_id
        call, _headers = get 'calls', call_id: call_id
        Types::Call.new call
      end

      # Hang up a call
      #
      # @param [String] call_id Call id
      #
      # @example
      #   bandwidth.hangup "c-xytsl6nfcayzsxdbqq7q36i"
      #
      def hangup call_id
        _body, _headers = post "calls/#{call_id}", state: 'completed'
        nil
      end

      # Transfer a call
      #
      # @param [String] call_id Call id
      # @param [String] target Phone number to transfer call to
      # @param [Hash] options Transfer options
      # @option options [String] :transfer_caller_id Set caller id
      # @option options [Audio::Sentence, Audio::File] :audio Audio file to play or text to speak
      #
      # @return [String] Call id
      #
      # @example Transfer setting caller id
      #   bandwidth.transfer "c-xytsl6nfcayzsxdbqq7q36i", "+19195551212", transfer_caller_id: "+19195553131"
      #
      # @example Transfer and speak text
      #   audio = Bandwidth::Audio::Sentence.new "Call has been transferred"
      #   bandwidth.transfer "c-xytsl6nfcayzsxdbqq7q36i", "+19195551212", audio: audio
      #
      def transfer call_id, target, options={}
        parameters = {state: 'transferring', transfer_to: target}
        parameters.merge!({transfer_caller_id: options[:transfer_caller_id]}) if options[:transfer_caller_id]
        parameters.merge!({whisper_audio: options[:audio].to_hash}) if options[:audio]

        _body, headers = post "calls/#{call_id}", parameters

        headers['location'].match(/[^\/]+$/)[0]
      end

      # Turn call recording on or off
      #
      # @param [String] call_id Call id
      #
      # @example
      #   bandwidth.recording_state "c-xytsl6nfcayzsxdbqq7q36i", true
      #
      def recording_enabled call_id, state
        post "calls/#{call_id}", recording_enabled: (!!state).to_s

        nil
      end

      # Play an audio or speak a sentence in a call
      #
      # @param [String] call_id Call id
      # @param [Audio::Sentence, Audio::File] audio Audio file to play or text to speak
      #
      # @example Plays an audio file in a phone call
      #   audio_file = Bandwidth::Audio::File.new "http://example.com/audio.mp3"
      #   bandwidth.play call_id, audio_file
      #
      # @example Speak a sentence in a phone call
      #   sentence = Bandwidth::Audio::Sentence.new "Hello, thank you for calling."
      #   bandwidth.play call_id, sentence
      #
      # @note See [Audio::Sentence] and [Audio::File] for more options
      #
      def play call_id, audio
        post "calls/#{call_id}/audio", audio.to_hash

        nil
      end

      # Send DTMF to the call
      #
      # @param [String] call_id Call id
      #
      # @example
      #   bandwidth.dtmf call_id, "1234"
      #
      def dtmf call_id, dtmf
        post "calls/#{call_id}/dtmf", {dtmf_out: dtmf}

        nil
      end

      # Wait until the specified number of DTMF digits are pressed
      #
      # @param [String] call_id Call id
      # @option options [String] :max_digits The maximum number of digits to collect, not including terminating digits (maximum 30)
      # @option options [String] :inter_digit_timeout Stop gathering if a DTMF digit is not detected in this many seconds (default 5.0; maximum 30.0)
      # @option options [String] :terminating_digits A string of DTMF digits that end the gather operation immediately if any one of them is detected (default "#"; an empty string means collect all DTMF until maxDigits or the timeout)
      # @option options [String] :tag A string you choose that will be included with the response and events for this gather operation
      # @option options [Audio::Sentence, Audio::File] :audio Audio file to play or text to speak
      #
      # @return [Types::DTMF]
      #
      # @example
      #   dtmf = bandwidth.gather call_id
      #   dtmf.digits # => "*123"
      #   dtmf.state # => "terminating-digit"
      #   dtmf.terminating_digit # => "#"
      #   dtmf.tag # => "abc123"
      #
      # @example The gather ends if either 0, #, or * is detected:
      #   dtmf = bandwidth.gather call_id, terminating_digits: "0#*"
      #
      # @example Plays or speaks to a call when gathering DTMF. Note a specical bargeable parameter to interrupt prompt (audio or sentence) at first digit gathered (default is true).
      #   audio = Bandwidth::Audio::File.new "http://example.com/audio.mp3", bargeable: false
      #   dtmf = bandwidth.gather call_id, audio: audio
      #
      def gather call_id, options={}
        # TODO: fail on wrong options
        options[:prompt] = options[:prompt].to_hash if options[:prompt]
        body, _headers = post "calls/#{call_id}/gather", options
      end

      # Retrieve all recordings related to the call
      #
      # @param [String] call_id Call id
      #
      # @return [Array<Types::Record>]
      #
      # @example
      #   records = bandwidth.call_records call_id
      #
      #   record = records.first
      #
      #   record.id # => "rec-togfrwqp2bxxezstzbzadra"
      #   record.media # => "https://.../v1/users/.../media/c-j4gferrrn72ivf3ov56ccay-1.wav"
      #   record.start_time # => 2013-02-08 12:05:17 UTC
      #   record.end_time # => 2013-02-08 13:15:55 UTC
      #   record.state # => "complete"
      #
      def call_records call_id
        LazyArray.new do |page, size|
          records, _headers = get "calls/#{call_id}/recordings", page: page, size: size

          records.map do |record|
            Types::Record.new record
          end
        end
      end
    end
  end
end
