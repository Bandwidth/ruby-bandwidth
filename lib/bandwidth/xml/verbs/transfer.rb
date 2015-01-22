module Bandwidth
  module Xml
    module Verbs
      # The Transfer verb is used to transfer the call to another number
      class Transfer
        include XmlVerb

        def to_xml(xml)
          xml.Transfer(compact_hash({
           'transferTo' => transfer_to || to,
           'transferCallerId' => transfer_caller_id || caller_id
          })) do
            if speak_sentence
              s = if speak_sentence.is_a?(SpeakSentence)
                  then speak_sentence
                  else SpeakSentence.new(speak_sentence)
                  end
              s.to_xml(xml)
            end
          end
        end
      end
    end
  end
end
