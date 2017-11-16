module Bandwidth
  module Xml
    module Verbs
      # The Transfer verb is used to transfer the call to another number
      class Transfer
        include XmlVerb

        def to_xml(xml)
          xml.Transfer(compact_hash({
           'transferTo' => transfer_to || to,
           'transferCallerId' => transfer_caller_id || caller_id,
           'requestUrl' => request_url,
           'requestUrlTimeout' => request_url_timeout,
           'callTimeout' => call_timeout,
           'tag' => tag,
          })) do
            def embedded_xml(xml, property, type)
              if property
                s = if property.is_a?(type)
                    then property
                    else type.new(property)
                    end
                s.to_xml(xml)
              end
            end
            numbers = phone_numbers
            numbers = [phone_number] if !numbers && phone_number
            (numbers || []).each do |n|
              xml.PhoneNumber(n)
            end
            embedded_xml(xml, speak_sentence, SpeakSentence)
            embedded_xml(xml, play_audio, PlayAudio)
            embedded_xml(xml, record, Record)
          end
        end
      end
    end
  end
end
