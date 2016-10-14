module Bandwidth
  RECORDING_PATH = 'recordings'

  # Retrieve call recordings,
  class Recording
    extend ClientWrapper
    include ApiItem

    # Retrieve a specific call recording information, identified by recordingId
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of recording
    # @return [Hash] recording information
    # @example
    #   recording = Recording.get(client, "id")
    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{RECORDING_PATH}/#{id}"))[0]
      Recording.new(item, client)
    end
    wrap_client_arg :get

    # List a user's call recordings
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] query options
    # @return [LazyEnumerator] list of recordings
    # @example
    #   recordings = Recording.list(client)
    def self.list(client, query = nil)
      get_data = lambda do
        items, headers = client.make_request(:get, client.concat_user_path(RECORDING_PATH), query)
        items = items.map do |item|
          Recording.new(item, client)
        end
        [items, headers]
      end
      LazyEnumerator.new(get_data, client)
    end
    wrap_client_arg :list

    # Request the transcription process to be started for the given recording id.
    # @return [LazyInstance] created transcription
    # @example
    #   transcription = recording.create_transcription()
    def create_transcription()
      headers = @client.make_request(:post, @client.concat_user_path("#{RECORDING_PATH}/#{id}/transcriptions"), {})[1]
      id = Client.get_id_from_location_header(headers[:location])
      LazyInstance.new(id, lambda { get_transcription(id) })
    end

    # Gets information about a transcription
    # @param transcription_id [String] id of transcription
    # @return [Hash] event data
    # @example
    #   transcription  = recording.get_transcription("id")
    def get_transcription(transcription_id)
      @client.make_request(:get, @client.concat_user_path("#{RECORDING_PATH}/#{id}/transcriptions/#{transcription_id}"))[0]
    end

    # Gets the list of transcriptions for a recording
    # @return [Array] list of events
    # @example
    #   transcriptions = recording.get_transcriptions()
    def get_transcriptions()
      @client.make_request(:get, @client.concat_user_path("#{RECORDING_PATH}/#{id}/transcriptions"))[0]
    end
  end
end
