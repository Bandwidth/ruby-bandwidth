module Bandwidth
  CALL_PATH = 'calls'
  class Call
    extend ClientWrapper
    include ApiItem

    def self.get(client, id)
      item = client.make_request(:get, client.concat_user_path("#{CALL_PATH}/#{id}"))[0]
      Call.new(item, client)
    end
    wrap_client_arg :get

    def self.list(client, query = nil)
      client.make_request(:get, client.concat_user_path(CALL_PATH), query)[0].map do |item|
        Call.new(item, client)
      end
    end
    wrap_client_arg :list

    def self.create(client, data)
      headers = client.make_request(:post, client.concat_user_path(CALL_PATH), data)[1]
      id = Client.get_id_from_location_header(headers[:location])
      self.get(client, id)
    end
    wrap_client_arg :create

    def update(data)
      @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}"), data)[0]
    end

    def play_audio(data)
      @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}/audio"), data)[0]
    end

    def speak_sentence(sentence, tag = nil)
      play_audio({:gender => "female", :locale => "en_US",
                  :voice => "kate", :sentence => sentence, :tag => tag})
    end

    def play_recording(url)
      play_audio({:file_url => url})
    end

    def set_dtmf(dtmf)
      @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}/dtmf"), {:dtmf_out => dtmf})[0]
    end

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
      get_gather(id)
    end

    def update_gather(gather_id, data)
      @client.make_request(:post, @client.concat_user_path("#{CALL_PATH}/#{id}/gather/#{gather_id}"), data)[0]
    end

    def get_gather(gather_id)
      @client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}/gather/#{gather_id}"))[0]
    end

    def get_event(event_id)
      @client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}/events/#{event_id}"))[0]
    end

    def get_events()
      @client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}/events"))[0]
    end

    def get_recordings()
      @client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}/recordings"))[0]
    end

    def hangup()
      update({:state => 'completed'})
      reload()
    end

    def answer_on_incoming()
      update({:state => 'active'})
      reload()
    end

    def reject_incoming()
      update({:state => 'rejected'})
      reload()
    end

    def recording_on()
      update({:recording_enabled => true})
      reload()
    end

    def recording_off()
      update({:recording_enabled => false})
      reload()
    end

    protected

    def reload()
      @data.merge!(@client.make_request(:get, @client.concat_user_path("#{CALL_PATH}/#{id}"))[0])
    end
  end
end
