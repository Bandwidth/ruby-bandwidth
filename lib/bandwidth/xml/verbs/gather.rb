module Bandwidth
  module Xml
    module Verbs
      # The Gather verb is used to collect digits for some period of time
      class Gather
        include XmlVerb

        def to_xml(xml)
          xml.Gather(compact_hash({
           'requestUrl' => request_url,
           'requestUrlTimeout' => request_url_timeout,
           'terminatingDigits' => terminating_digits,
           'maxDigits' => max_digits,
           'interDigitTimeout' => inter_digit_timeout,
           'bargeable' => bargeable
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
            embedded_xml(xml, speak_sentence, SpeakSentence)
            embedded_xml(xml, play_audio, PlayAudio)
          end
        end
      end
    end
  end
end
