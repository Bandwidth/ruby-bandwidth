module Bandwidth
  CALL_PATH = 'calls'

  # The Calls resource lets you make phone calls and view information about previous inbound and outbound calls.
  class Call
    extend ClientWrapper
    include ApiItem
    include PlayAudioExtensions

    # Get information about a call that was made or received
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of call
    # @return [Call] Call instance
    # @example
    #   call = Call.get(client, "1")
    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{CALL_PATH}/#{id}"))[0]
      Call.new(item, client)
    end
    wrap_client_arg :get

    # Get a list of previous calls that were made or received
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] query options
    # @return [Enumerator] array of Call ionstances
    # @example
    #   calls = Call.list(client)
    def self.list(client, query = nil)
      get_data = lambda do
        items, headers = client.make_request(:get, client.concat_user_path(CALL_PATH), query)
        items = items.map do |item|
          Call.new(item, client)
        end
        [items, headers]
      end
      LazyEnumerator.new(get_data, client)
    end
    wrap_client_arg :list

    # Make a phone call
    # @param client [Client] optional client instance to make requests
    # @param data [Hash] data to create a call
    # @return [LazyInstance] created call
    # @example
    #   call = Call.create(client, {:from=>"from", :to=>"to"})
    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(CALL_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      LazyInstance.new(id, lambda { self.get(client, id) })
    end
    wrap_client_arg :create

    # Make changes to an active phone call. E.g.: transfer, hang up, answer or reject incoming calls, call recording, etc.
    # @param data [Hash] changed data
    # @example
    #   call.update(:state=>"completed") #hangup a call
    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}"), data)[0]
    end

    # Play an audio or speak a sentence in a call
    # @param data [Hash] options for play audio
    # @example
    #   call.play_audio(:file_url => "http://host1")
    def play_audio(data)
      @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}/audio"), data)[0]
    end

    # Send DTMF
    # @param dtmf [String] dtmf value to send
    # @example
    #   call.send_dtmf("0")
    def set_dtmf(dtmf)
      @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}/dtmf"), {:dtmf_out => dtmf})[0]
    end

    # Gather the DTMF digits pressed
    # @param data [String|Hash] sentence to speak on creating cather if string, otherwise it is hash with gather options
    # @return [LazyInstance] created gather
    # @example
    #   gather = call.create_gather("Press a digit")
    #   gather = call.create_gather(:max_digits => 1, :prompt => {:sentence => "Press a digit",  :bargeable => true })
    def create_gather(data)
      d = if data.is_a?(String)
            {
              :tag => id, :max_digits => 1,
              :prompt => {:locale => 'en_US', :gender => 'female', :sentence => data, :voice => 'kate', :bargeable => true }
            }
          else
            data
          end
      headers = @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}/gather"), d)[1]
      id = Client.get_id_from_location_header(headers[:location])
      LazyInstance.new(id, lambda { get_gather(id) })
    end

    # Update the gather DTMF (Stop Gather)
    # @param gather_id [String] id of gather
    # @param data [Hash] changed data
    # @example
    #   call.update_gather("1", :state => "completed")
    def update_gather(gather_id, data)
      @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}/gather/#{gather_id}"), data)[0]
    end

    # Get the gather DTMF parameters and results
    # @param gather_id [String] id of gather
    # @return [Hash] gather options
    # @example
    #   gather = call.get_gather("id")
    def get_gather(gather_id)
      @client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}/gather/#{gather_id}"))[0]
    end

    # Gets information about one call event
    # @param event_id [String] id of event
    # @return [Hash] event data
    # @example
    #   e = call.get_event("id")
    def get_event(event_id)
      @client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}/events/#{event_id}"))[0]
    end

    # Gets the list of call events for a call
    # @return [Array] list of events
    # @example
    #   events = call.get_events()
    def get_events()
      @client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}/events"))[0]
    end

    # Retrieve all recordings related to the call
    # @return [Array] list of recordings
    # @example
    #   recordings = call.get_recordings()
    def get_recordings()
      @client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}/recordings"))[0]
    end

    # Hangup a call
    def hangup()
      update({:state => 'completed'})
    end

    # Answer on an incoming call
    def answer_on_incoming()
      update({:state => 'active'})
    end

    # Reject a call
    def reject_incoming()
      update({:state => 'rejected'})
    end

    # Tune on recording of a call
    def recording_on()
      update({:recording_enabled => true})
    end

    # Tune off recording of a call
    def recording_off()
      update({:recording_enabled => false})
    end

  end
end
