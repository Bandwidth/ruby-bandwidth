module Bandwidth
  module Xml
    module Verbs
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
