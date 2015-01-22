module Bandwidth
  RECORDING_PATH = 'recordings'

  # Retrieve call recordings,
  class Recording
    extend ClientWrapper

    # Retrieve a specific call recording information, identified by recordingId
    # @param client [Client] optional client instance to make requests
    # @param id [String] id of recording
    # @return [Hash] recording information
    # @example
    #   recording = Recording.get(client, "id")
    def self.get(client, id)
      client.make_request(:get, client.concat_user_path("#{RECORDING_PATH}/#{id}"))[0]
    end
    wrap_client_arg :get

    # List a user's call recordings
    # @param client [Client] optional client instance to make requests
    # @param query [Hash] query options
    # @return [Array] list of recordings
    # @example
    #   recordings = Recording.list(client)
    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(RECORDING_PATH), query)[0]
    end
    wrap_client_arg :list
  end
end
