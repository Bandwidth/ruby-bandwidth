module Bandwidth
  # Generates methods speak_sentence and play_recording for a class using instance method play_audio
  module PlayAudioExtensions
    # Speak a sentence
    # @param sentence [String[ sentence to speak
    # @param tag [String] optional tag value
    # @param gender [String] optional gender of voice
    # @param voice [String] optional voice name
    def speak_sentence(sentence, tag = nil, gender = "female", voice = "kate")
      play_audio({:gender => gender || "female", :locale => "en_US",
                  :voice => voice || "kate", :sentence => sentence, :tag => tag})
    end

    # Play an audio by url
    # @param url [String] url of audio resource
    # @param tag [String] optional tag value
    def play_recording(url, tag = nil)
      play_audio({:file_url => url, :tag => tag})
    end
  end
end
