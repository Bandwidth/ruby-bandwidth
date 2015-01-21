module Bandwidth
  module Xml
    module Verbs
      class PlayAudio
        include XmlVerb

        def to_xml(xml)
          xml.PlayAudio(url, compact_hash({
           'digits' => digits
          }))
        end
      end
    end
  end
end
