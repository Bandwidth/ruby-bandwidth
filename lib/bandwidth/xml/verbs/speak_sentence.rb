module Bandwidth
  module Xml
    module Verbs
      class SpeakSentence
        include XmlVerb

        def to_xml(xml)
          xml.SpeakSentence(sentence, compact_hash({
           'voice' => voice,
           'locale' => locale,
           'gender' => gender
          }))
        end
      end
    end
  end
end
