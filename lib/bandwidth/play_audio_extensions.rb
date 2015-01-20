module Bandwidth
  module PlayAudioExtensions
    def speak_sentence(sentence, tag = nil)
      play_audio({:gender => "female", :locale => "en_US",
                  :voice => "kate", :sentence => sentence, :tag => tag})
    end
    def play_recording(url, tag = nil)
      play_audio({:file_url => url, :tag => tag})
    end
  end
end
