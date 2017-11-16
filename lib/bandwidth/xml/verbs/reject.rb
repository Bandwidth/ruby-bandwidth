module Bandwidth
  module Xml
    module Verbs
      # The Reject verb is used to reject incoming calls
      class Reject
        include XmlVerb

        def to_xml(xml)
          warn "[DEPRECATION] Verb 'Reject' will be removed in Bandwidth XML v2"
          xml.Reject(compact_hash({
           'reason' => reason
          }))
        end
      end
    end
  end
end
