module Bandwidth
  module Xml
    module Verbs
      # The Reject verb is used to reject incoming calls
      class Reject
        include XmlVerb

        def to_xml(xml)
          xml.Reject(compact_hash({
           'reason' => reason
          }))
        end
      end
    end
  end
end
